export const pagination = (req, res, next) => {
    const page = Number(req.query.page) || 1;
    const results = Number(req.query.results) || 5;

    req.pagination = {
        page,
        results,
    };

    next();
};