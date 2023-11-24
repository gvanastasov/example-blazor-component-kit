function Text-Pound-Wrapper {
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