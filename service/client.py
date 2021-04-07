import grpc

import sys

sys.path.insert(0, 'service/')

from service_spec import stanza_pb2
from service_spec import stanza_pb2_grpc

channel = grpc.insecure_channel('localhost:2379')

stub = stanza_pb2_grpc.stanza_nlpStub(channel)

number = stanza_pb2.stanzaMessage(value="Hello how are you ")

response = stub.preprocess(number)

print(response.value)