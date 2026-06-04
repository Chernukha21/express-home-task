import express from 'express';
import {
    createTask,
    getAllTasks,
    getSingleTaskById,
    removeTaskById,
    updateTaskById
} from "./controllers/taskController.js";
import {validateTaskOnCreate, validateTaskOnUpdate} from "./middleware/validation.js";
import {errorHandlers, errorValidationHandler} from "./middleware/errors.js";
import {pagination} from "./middleware/pagination.js";

const app = express();

app.use(express.json());

app.get('/', (req, res) => {
    res.status(200).send('Express server started');
});
app.get('/tasks', pagination, getAllTasks);
app.get('/tasks/:id', getSingleTaskById);
app.post('/tasks', validateTaskOnCreate, createTask);
app.patch('/tasks/:id', validateTaskOnUpdate, updateTaskById);
app.delete('/tasks/:id', removeTaskById);

app.use((req, res) => {
    res.status(404).json({
        message: 'Route not found',
    });
});

app.use(errorValidationHandler, errorHandlers);
export default app;