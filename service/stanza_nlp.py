# Import the package
import stanza
import json

stanza.download('en')

# class stanfordPipline():
#     def __init__(self):
#         stanza.download('en')
#         self.en_nlp = stanza.Pipeline('en')

#     def preprocess(self,text):
#         self.en_doc = en_nlp(text)
#         return en_doc

def preprocess(text):
    en_nlp = stanza.Pipeline('en')
    en_doc = en_nlp(text)
    return  json.dumps(en_doc.to_dict()[0])



# result = preprocess("Hello how are you")
# print(result.to_dict()[0])


# print(type(json.dumps(result.to_dict()[0])))