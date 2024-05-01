$BlueprintList = @()

#Add Item Blueprints
$WebResponseitems = Invoke-WebRequest "https://arkids.net/items/"
$itemnames = $webresponseitems.links.href | select | where {$_ -match "`/item`/"} | select -unique
foreach ($item in $itemnames){
    $itemshortname = ($item -split("/"))[2]
    $itemurl = "https://arkids.net" + $item
    $WebResponseItem = Invoke-WebRequest $itemurl
    $result = ($WebResponseItem.ParsedHtml.getElementsByTagName('div') | where {$_.classname -eq 'copy-box'}).innerHTML[1]
    $result1 = ($result -split '>')[0]
    $result2 = ($result1 -split ';')[1]
    $result3 = $result2 -replace ".{5}$"
    $ItemObj = `
	      [pscustomobject]@{
	      "ItemName"       = $itemshortname
	      "BPPath"         = $result3
          "Type"           = "Item"
	    }
	$BlueprintList += $ItemObj
}

for ($i = 1; $i -lt 43; $i++) {
    $WebResponseitems = Invoke-WebRequest "https://arkids.net/items/page/$i"
    $itemnames = $webresponseitems.links.href | select | where {$_ -match "`/item`/"} | select -unique
    foreach ($item in $itemnames){
        $itemshortname = ($item -split("/"))[2]
        $itemurl = "https://arkids.net" + $item
        $WebResponseItem = Invoke-WebRequest $itemurl
        $result = ($WebResponseItem.ParsedHtml.getElementsByTagName('div') | where {$_.classname -eq 'copy-box'}).innerHTML[1]
        $result1 = ($result -split '>')[0]
        $result2 = ($result1 -split ';')[1]
        $result3 = $result2 -replace ".{5}$"
        $ItemObj = `
	      [pscustomobject]@{
	      "ItemName"       = $itemshortname
	      "BPPath"         = $result3
          "Type"           = "Item"
	    }
	$BlueprintList += $ItemObj
    }
}

#Add Dino Blueprints
$WebResponsedinos = Invoke-WebRequest "https://arkids.net/creatures/"
$dinonames = $webresponsedinos.links.href | select | where {$_ -match "`/creature`/"} | select -unique
foreach ($dino in $dinonames){
    $dinoshortname = ($dino -split("/"))[2]
    $dinourl = "https://arkids.net" + $dino
    $WebResponsedino = Invoke-WebRequest $dinourl
    $result = ($WebResponsedino.ParsedHtml.getElementsByTagName('div') | where {$_.classname -eq 'copy-box'}).innerHTML[1]
    $result1 = ($result -split '>')[0]
    $result2 = ($result1 -split ';')[1]
    $result3 = $result2 -replace ".{5}$"
    $DinoObj = `
	      [pscustomobject]@{
	      "itemName"       = $dinoshortname
	      "BPPath"         = $result3
          "Type"           = "Dino"
	    }
	$BlueprintList += $DinoObj
}

$BlueprintList | export-csv "c:\temp\blueprintlist.csv" -notypeinformation