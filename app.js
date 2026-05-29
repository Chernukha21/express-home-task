import express from 'express';
import {
    createTask,
    getAllTasks,
    getSingleTaskById,
    removeTaskById,
    updateTaskById
} from "./controllers/taskController.js";

const app = express();

app.use(express.json());

app.get('/', (req, res) => {
    res.status(200).send('Express server started');
});
app.get('/tasks', getAllTasks);
app.get('/tasks/:id', getSingleTaskById);
app.post('/tasks', createTask);
app.patch('/tasks/:id', updateTaskById);
app.delete('/tasks/:id', removeTaskById);

export default app;