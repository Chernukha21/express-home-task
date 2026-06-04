import * as yup from "yup";
import { parse, isValid, startOfDay } from "date-fns";

const BODY_VALIDATION_SCHEMA = yup
    .string()
    .trim()
    .min(2)
    .max(256);

const DEADLINE_VALIDATION_SCHEMA = yup
    .string()
    .trim()
    .test(
        'is-valid-date',
        'Deadline must be a valid date (YYYY-MM-DD)',
        (value) => {
            if (!value) return true;
            const parsed = parse(value, 'yyyy-MM-dd', new Date());
            return isValid(parsed);
        }
    )
    .test(
        'is-today-or-future',
        'Deadline cannot be in the past',
        (value) => {
            if (!value) return true;
            const parsed = parse(value, 'yyyy-MM-dd', new Date());
            if (!isValid(parsed)) return true;

            return startOfDay(parsed) >= startOfDay(new Date());
        }
    );

export const CREATE_TASK_VALIDATION_SCHEMA = yup.object({
    body: BODY_VALIDATION_SCHEMA.required(),
    deadline: DEADLINE_VALIDATION_SCHEMA.required(),
});

export const UPDATE_TASK_VALIDATION_SCHEMA = yup.object({
    body: BODY_VALIDATION_SCHEMA,
    deadline: DEADLINE_VALIDATION_SCHEMA,
    isDone: yup.boolean(),
});