import { Worker } from 'bullmq';
import { UserCreated, UserUpdated, UserDeleted } from '../events/user.events';
import logger from '../../logger';

// Initialize the worker that processes jobs from the "webhook-events" queue
const worker = new Worker('auth-queue', async job => {
  try {
    const { eventType, data } = job.data;

    console.log("queue started")
    // Process the event based on its type
    switch (eventType) {
      case 'user.created':
        await UserCreated(data);
        break;
      case 'user.updated':
        await UserUpdated(data);
        break;
      case 'user.deleted':
        await UserDeleted(data);
        break;
      default:
        logger.warn(`Unhandled event type: ${eventType}`);
    }
  } catch (error: any) {
    logger.error('Error processing job', {
      error: error.message,
      stack: error.stack,
    });
    throw error; // BullMQ will automatically retry the job based on queue settings
  }
});

// Monitor worker events (completed, failed)
worker.on('completed', job => {
  logger.info(`Job completed: ${job.id}`);
});

worker.on('failed', (job:any, err:any) => {
  logger.error(`Job failed: ${job.id}`, { error: err.message });
});
