FROM public.ecr.aws/lambda/nodejs:18

# Copy function code
COPY ./src ${LAMBDA_TASK_ROOT}

RUN echo ${LAMBDA_TASK_ROOT}

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "index.handler" ]