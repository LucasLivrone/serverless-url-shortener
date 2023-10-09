def lambda_handler(event, context):
    request = event['Records'][0]['cf']['request']

    # Check if the URI doesn't start with "/url-shortener"
    if not request['uri'].startswith('/url-shortener'):
        # Modify the URL path to include "url-shortener" part
        request['uri'] = '/url-shortener' + request['uri']

    return request
