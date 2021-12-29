#Add your key here
$key = "<YOUR_KEY>"
$endpoint = "<YOUR_ENDPOINT>"
#$location = "<YOUR_LOCATION>"


#The endpoint is global for the Translator service, DO NOT change it 
$endpoint="https://api.cognitive.microsofttranslator.com/"

#Text to be translated 
$text="Hello"

# Code to call Text Analytics service to analyze sentiment in text
$headers = @{}
$headers.Add( "Ocp-Apim-Subscription-Key", $key )
$headers.Add( "Ocp-Apim-Subscription-Region", $location )
$headers.Add( "Content-Type","application/json" )

$body = "[{'text': '$text'}]" 

Write-Host "Translating text..."
$parameters = @{
    Method = "Post"
    Uri = "$endpoint/translate?api-version=3.0&from=en&to=fr&to=it&to=zh-Hans"
    Headers = $headers
    Body = $body
}
$result = Invoke-RestMethod @parameters

$analysis = $result.content | ConvertFrom-Json
$french = $analysis.translations[0] 
$italian = $analysis.translations[1] 
$chinese = $analysis.translations[2] 
Write-Host ("Original Text: $text`nFrench Translation: $($french.text)`nItalian Translation: $($italian.text)`nChinese Translation: $($chinese.text)`n")

# Code to Translate audio to text in another language 
$wav = "./data/translation/english.wav"

$headers = @{}
$headers.Add( "Ocp-Apim-Subscription-Key", $key )
$headers.Add( "Content-Type","audio/wav" )

Write-Host "Translating audio..."
$parameters = @{
    Method = "Post"
    Uri = "https://$location.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US"
    Headers = $headers
    InFile = $wav
}
$audio_result= Invoke-RestMethod @parameters

$original_audio_text = $audio_result.DisplayText
Write-Host ("The audio said '$($original_audio_text)'")

# Code to call translate audio text to different language 
$headers = @{}
$headers.Add( "Ocp-Apim-Subscription-Key", $key )
$headers.Add( "Ocp-Apim-Subscription-Region", $location )
$headers.Add( "Content-Type","application/json" )

$body = "[{'text': '$original_audio_text'}]" 

Write-Host "Translating text from audio to French..."
$parameters = @{
    Method = "Post"
    Uri = "$endpoint/translate?api-version=3.0&from=en&to=fr"
    Headers = $headers
    Body = $body
}
$result = Invoke-Webrequest @parameters

$analysis = $result.content | ConvertFrom-Json
$french_translation = $analysis.translations.text
Write-Host ("Translated text: '$french_translation'")











