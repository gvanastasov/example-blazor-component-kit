function Format-PoundBox {
    param (
        [int]$maxBoundBox = 80,
        [string]$Text
    )

    $border = '#' * $maxBoundBox
    $padding = '#' + (' ' * ($maxBoundBox - 2)) + '#'
    $textInternal = '#  ' + $Text + (' ' * ($maxBoundBox - 4 - $Text.Length)) + '#'

    $result = @"
$border
$padding
$textInternal
$padding
$border
"@

    return $result
}

function Convert-To-TrainCase {
    param (
        [string]$inputString
    )

    $trainCaseString = $inputString -creplace '([A-Z])', '-$1'

    $trainCaseString = ($trainCaseString -replace '^-', '').ToLower()

    return $trainCaseString
}