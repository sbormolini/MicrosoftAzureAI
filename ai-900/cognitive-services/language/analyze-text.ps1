$key = "<YOUR_KEY>"
$endpoint = "<YOUR_ENDPOINT>"
#$location = "<YOUR_LOCATION>"


# Code to call Text Analytics service to analyze sentiment in text
$txt_file = "review1.txt"
if ($args.count -gt 0 -And $args[0] -in ("review1.txt", "review2.txt", "review3.txt", "review4.txt"))
{
    $txt_file = $args[0]
}
$url = "https://raw.githubusercontent.com/MicrosoftLearning/AI-900-AIFundamentals/main/data/text/reviews/$txt_file"

$txt = (Invoke-webrequest -URI $url).Content

$headers = @{}
$headers.Add( "Ocp-Apim-Subscription-Key", $key )
$headers.Add( "Content-Type","application/json" )

#region : Language Detection
$data = @{
    'documents' = @(
        @{
            "id" = "1"
            "text" = "$txt"
        }
    )
} | ConvertTo-Json

Write-Host("***Detecting Language***")
$parameters = @{
    Method = "Post"
    Uri = "$endpoint/text/analytics/v3.1/languages"
    Headers = $headers
    Body = $data | ConvertTo-Json -Depth 6
}
$result = Invoke-RestMethod @parameters

$analysis = ($result | ConvertFrom-Json)
$langName = $analysis.documents.detectedLanguage.name
$langCode = $analysis.documents.detectedLanguage.iso6391Name
$langScore = $analysis.documents.detectedLanguage.confidenceScore

Write-Host ("  - Language: $langName`n  - Code: $langCode`n  - Score: $langScore")
#endregion

#region : Key Phrases
$data = @{
    'documents' = @(
        @{
            "id" = "1"
            "text" = "$txt"
        }
    )
} | ConvertTo-Json

Write-Host "`n`n***Finding Key Phrases***"
$parameters = @{
    Method = "Post"
    Uri = "$endpoint/text/analytics/v3.1/keyPhrases"
    Headers = $headers
    Body = $data | ConvertTo-Json -Depth 6
}
$result = Invoke-RestMethod @parameters

$analysis = ($result | ConvertFrom-Json)

$keyPhrases = $analysis.documents.keyPhrases

Write-Host "  - Key Phrases: "
foreach($keyPhrase in $keyPhrases) 
{
    Write-Host ("    ", $keyPhrase)
}
#endregion

#region : Sentiment
$data = @{
    'documents' = @(
        @{
            "id" = "1"
            "text" = "$txt"
        }
    )
} | ConvertTo-Json

Write-Host "`n`n***Analyzing Sentiment***"
$parameters = @{
    Method = "Post"
    Uri = "$endpoint/text/analytics/v3.1/sentiment"
    Headers = $headers
    Body = $data | ConvertTo-Json -Depth 6
}
$result = Invoke-RestMethod @parameters

$analysis = ($result | ConvertFrom-Json)

$sentiment = $analysis.documents.sentiment
$positive = $analysis.documents.confidenceScores.positive
$neutral = $analysis.documents.confidenceScores.neutral
$negative = $analysis.documents.confidenceScores.negative

Write-Host ("  - A $sentiment sentiment based on these scores:`n    - Positive: $positive`n    - Neutral: $neutral`n    - Negative: $negative")
#endregion

#region : Known Entities
$data = @{
    'documents' = @(
        @{
            "id" = "1"
            "text" = "$txt"
        }
    )
} | ConvertTo-Json

Write-Host "`n`n***Identifying known entities***"
$parameters = @{
    Method = "Post"
    Uri = "$endpoint/text/analytics/v3.1/entities/linking"
    Headers = $headers
    Body = $data | ConvertTo-Json -Depth 6
}
$result = Invoke-RestMethod @parameters

$analysis = ($result | ConvertFrom-Json)

$entities = $analysis.documents[0].entities

foreach ($entity in $entities) 
{
    $entityName = $entity.name 
    $entityUrl = $entity.url 
    Write-Host ("  - $entityName : $entityUrl")
}
#endregion