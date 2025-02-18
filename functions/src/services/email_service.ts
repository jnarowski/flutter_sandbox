import * as nodemailer from "nodemailer";
import * as functions from "firebase-functions";

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: functions.config().email.user,
    pass: functions.config().email.pass,
  },
});

export interface SendInviteEmailParams {
  to: string;
  verificationCode: string;
}

export async function sendInviteEmail({
  to,
  verificationCode,
}: SendInviteEmailParams): Promise<void> {
  const mailOptions = {
    from: `"Baby Tracker" <${functions.config().email.user}>`,
    to,
    subject: "You've been invited to Baby Tracker!",
    html: `
      <h1>Welcome to Baby Tracker!</h1>
      <p>You've been invited to join a Baby Tracker account.</p>
      <p>Your verification code is: <strong>${verificationCode}</strong></p>
      <p>You'll need this code when you sign up for your account.</p>
      <br>
      <p>Download the app and get started!</p>
    `,
  };

  await transporter.sendMail(mailOptions);
} 