# blog-translates

## Description
A simple service for handling text translating in a blog microservice-based demo project

Stack: Ruby, using Sinatra.

## Endpoints

### /translates/languages
Returns a JSON with the language name and the [ISO 639-1 language code (3-letter format)](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) available to translate.


Sample calls:

```
    GET /translates/languages
    returns 'application/json'
```

```json
	{
        "English": "eng",
        "Spanish": "spa",
        "Swedish": "swe",
        "German": "ger",
        "French": "fra"
    }
```


#### /translates/{language}/post/{post-id}

Connects to an external service via the `post-id` identifier to obtain the specific post content (expected to be in English) and traduces the text to `language` [ISO 639-1 language code (3-letter format)](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes):

Sample calls

```
    GET /translates/spa/posts/1
    returns 'application/json'
```

```json
    {
        "content": "Este es un post para traducir con una imagen de #messi#"
    }
```

## Other endpoints

Used for Prana and Netflix OSS tools.

### /healthcheck

Basic health check information about the application. No real test of the service capabilities at this point, a mere 200 response.

```
    GET /healthcheck
    returns 'application/json'
```

```json
   {
      "healthcheck": "ok"
    }
```

### /status

A simple response for the Eureka interface links. A mere 200 response.

```
    GET /status
    returns 'application/json'
```

```json
   {
      "status": "ok"
    }
```

## 3rd party tools used in the example
Text translation API from Language Cloud service (Trial): 
https://languagecloud.sdl.com/translation-toolkit/api-documentation

Google Translator API has no free tier.

