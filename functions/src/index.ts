import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";
import { sendInviteEmail } from "./services/email_service";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

admin.initializeApp();

// Initialize nodemailer with Gmail
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: functions.config().email.user,
    pass: functions.config().email.pass,
  },
});

export const helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

export const sendInvite = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated."
    );
  }

  const { email, verificationCode } = data;

  if (!email || !verificationCode) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Email and verification code are required."
    );
  }

  try {
    await sendInviteEmail({
      to: email,
      verificationCode,
    });
    return { success: true };
  } catch (error) {
    console.error("Error sending email:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Error sending invitation email."
    );
  }
});
