import 'dotenv/config';
import { app } from './app.js';

const port = Number(process.env.PORT ?? 8080);

const server = app.listen(port, '0.0.0.0', (error?: Error) => {
  if (error) {
    console.error('MoveWell backend failed to start:', error);
    process.exitCode = 1;
    return;
  }
  console.log(`MoveWell backend listening on port ${port}`);
});

for (const signal of ['SIGINT', 'SIGTERM'] as const) {
  process.on(signal, () => {
    server.close(() => process.exit(0));
  });
}
