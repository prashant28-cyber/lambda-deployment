FROM public.ecr.aws/lambda/python:3.9

COPY app/ /var/task/
COPY requirements.txt /var/task/

RUN pip install -r /var/task/requirements.txt

CMD ["main.lambda_handler"]
