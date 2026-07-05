const express = require('express');
const cors = require('cors');
const crypto = require('crypto');
require('dotenv').config();

// --- Fail fast if required env vars are missing ---
// Senior habit: never let a misconfigured server silently start and fail on the first request.
const REQUIRED_ENV = ['YOOKASSA_SHOP_ID', 'YOOKASSA_SECRET_KEY', 'YOOKASSA_RETURN_URL'];
for (const key of REQUIRED_ENV) {
    if (!process.env[key]) {
        console.error(`FATAL: Missing required env var ${key}`);
        process.exit(1);
    }
}

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

// Temporary in-memory store — replace with a real DB before production.
// Documented risk: wiped on every restart, not shared across instances if you scale horizontally.
const activeTransactions = {};

// --- Precompute auth header once, not on every request ---
const YOOKASSA_AUTH = Buffer.from(
    `${process.env.YOOKASSA_SHOP_ID}:${process.env.YOOKASSA_SECRET_KEY}`
).toString('base64');

/**
 * Basic request validation helper.
 * Senior habit: validate at the edge, don't trust client input past this point.
 */
function validatePaymentRequest(body) {
    const { amount, orderId } = body;

    if (!orderId || typeof orderId !== 'string') {
        return 'orderId is required and must be a string';
    }
    const parsedAmount = parseFloat(amount);
    if (!amount || isNaN(parsedAmount) || parsedAmount <= 0) {
        return 'amount is required and must be a positive number';
    }
    return null; // no error
}

/**
 * 1. CREATE PAYMENT ENDPOINT
 */
app.post('/api/payments/create', async (req, res) => {
    const validationError = validatePaymentRequest(req.body);
    if (validationError) {
        return res.status(400).json({ error: validationError });
    }

    const { amount, orderId } = req.body;
    const idempotencyKey = crypto.randomUUID();

    try {
        const response = await fetch('https://api.yookassa.ru/v3/payments', {
            method: 'POST',
            headers: {
                Authorization: `Basic ${YOOKASSA_AUTH}`,
                'Idempotence-Key': idempotencyKey,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                amount: { value: parseFloat(amount).toFixed(2), currency: 'RUB' },
                capture: true,
                confirmation: {
                    type: 'redirect',
                    return_url: process.env.YOOKASSA_RETURN_URL,
                },
                description: `Payment for Order #${orderId}`,
                metadata: { order_id: orderId },
            }),
        });

        const paymentData = await response.json();

        if (!response.ok) {
            // Log full detail server-side only — never leak provider error internals to the client.
            console.error('YooKassa API Error Details:', paymentData);
            throw new Error(paymentData.description || 'YooKassa API Error');
        }

        activeTransactions[orderId] = {
            id: paymentData.id,
            amount,
            status: 'pending',
            created_at: new Date().toISOString(),
        };

        return res.json({
            paymentId: paymentData.id,
            paymentUrl: paymentData.confirmation.confirmation_url,
        });
    } catch (error) {
        console.error('Payment Creation Failed:', error.message);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});

/**
 * 2. YOOKASSA WEBHOOK ENDPOINT
 */
app.post('/api/payments/webhook', async (req, res) => {
    try {
        const event = req.body;

        if (event.type === 'notification' && event.event === 'payment.succeeded') {
            const paymentObj = event.object;
            const paymentId = paymentObj.id;
            const orderId = paymentObj.metadata && paymentObj.metadata.order_id;

            if (!orderId) {
                console.warn('Webhook received without order_id metadata:', paymentId);
            } else if (activeTransactions[orderId]) {
                activeTransactions[orderId].status = 'succeeded';
                activeTransactions[orderId].updated_at = new Date().toISOString();
            } else {
                // Fallback in case the in-memory store was wiped by a restart mid-flow.
                activeTransactions[orderId] = {
                    id: paymentId,
                    status: 'succeeded',
                    updated_at: new Date().toISOString(),
                };
            }
            console.log(`Payment successful for Order #${orderId} (ID: ${paymentId})`);
        }

        // Always 200 so YooKassa stops retrying, even on unexpected event types.
        res.status(200).send('OK');
    } catch (error) {
        console.error('Webhook processing error:', error.message);
        res.status(200).send('Error Processed');
    }
});

/**
 * 3. CHECK STATUS ENDPOINT
 */
app.get('/api/payments/status/:orderId', (req, res) => {
    const { orderId } = req.params;
    const transaction = activeTransactions[orderId];

    if (!transaction) {
        return res.status(404).json({ status: 'not_found' });
    }
    return res.json({ status: transaction.status });
});

// --- Catch-all error handler for anything unhandled above ---
app.use((err, req, res, next) => {
    console.error('Unhandled error:', err);
    res.status(500).json({ error: 'Internal Server Error' });
});

app.listen(PORT, () => {
    console.log(`Independent Payment Server running on port ${PORT}`);
});



// curl -u 517394:test_*g5ubqAjnO_seB9VTFoIOiaHPJzCBkvPXJ76MiU8NByMo \
//   https://api.yookassa.ru/v3/payments \
//   -H "Content-Type: application/json" \
//   -H "Idempotence-Key: $(uuidgen)" \
//   -d '{"amount":{"value":"10.00","currency":"RUB"},"confirmation":{"type":"redirect","return_url":"https://regred-rainbowbridge.ru/payment-success"},"capture":true,"description":"test"}'

// {
//   "type" : "error",
//   "id" : "019f30bf-07d8-799f-8e3e-7a7621b1940d",
//   "description" : "Authentication type is not allowed",
//   "parameter" : "Authorization",
//   "code" : "invalid_credentials"
// }



// curl https://api.yookassa.ru/v3/refunds \
//   -X POST \
//   -u <Идентификатор магазина>:<Секретный ключ> \
//   -H 'Idempotence-Key: <Ключ идемпотентности>' \
//   -H 'Content-Type: application/json' \
//   -d '{
//         "amount": {
//           "value": "2.00",
//           "currency": "RUB"
//         },
//         "payment_id": "215d8da0-000f-50be-b000-0003308c89be"
//       }'


// curl https://api.yookassa.ru/v3/payments \
//   -X POST \
//   -u 1402230:test_I4ICupLPSLCUYeavnsBjhdIUKkmEFdGqaZ4kwOmuAt8 \
//   -H "Idempotence-Key: $(uuidgen)" \
//   -H 'Content-Type: application/json' \
//   -d '{
//         "amount": {
//           "value": "10.00",
//           "currency": "RUB"
//         },
//         "capture": true,
//         "confirmation": {
//           "type": "redirect",
//           "return_url": "https://regred-rainbowbridge.ru/payment-success"
//         },
//         "description": "Test payment",
//         "metadata": {
//           "order_id": "test_order_123"
//         }
//       }'


// {
//   "id" : "31dc0762-000f-5000-b000-1f28ef7800e8",
//   "status" : "pending",
//   "amount" : {
//     "value" : "10.00",
//     "currency" : "RUB"
//   },
//   "description" : "Test payment",
//   "recipient" : {
//     "account_id" : "1402230",
//     "gateway_id" : "2784196"
//   },
//   "created_at" : "2026-07-05T06:03:14.915Z",
//   "confirmation" : {
//     "type" : "redirect",
//     "confirmation_url" : "https://yoomoney.ru/checkout/payments/v2/contract?orderId=31dc0762-000f-5000-b000-1f28ef7800e8"
//   },
//   "test" : true,
//   "paid" : false,
//   "refundable" : false,
//   "metadata" : {
//     "order_id" : "test_order_123"
//   }
// }