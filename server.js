import http from 'http';
import app from './app.js';
const PORT = process.env.PORT || 5000;

const httpServer = http.createServer(app);
httpServer.listen(PORT, () => console.log(`Listening on ${PORT}`));

