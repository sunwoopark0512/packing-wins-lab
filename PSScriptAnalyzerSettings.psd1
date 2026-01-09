@{
    # Custom rules for packing-wins-lab project

    # Rule: PSAvoidUsingCmdletAliases
    # Desc: Avoid using cmdlet aliases for clarity
    Enable = $true

    # Rule: PSAvoidUsingEmptyCatchBlock
    # Desc: Catch blocks should have handlers
    Enable = $true

    # Rule: PSAvoidUsingWriteHost
    # Desc: Prefer output over Write-Host
    Enable = $true

    # Rule: PSUseShouldProcessForNewVariable
    # Desc: Use ShouldProcess for variables that accept pipeline input
    Enable = $true

    # Rule: PSUseApprovedVerbs
    # Desc: Use approved PowerShell verbs for function names
    Enable = $true
    ApprovedVerbs = @(
        'Get',
        'Set',
        'New',
        'Update',
        'Publish',
        'Start',
        'Stop',
        'Test',
        'Invoke'
    )

    # Rule: PSAvoidGlobalVars
    # Desc: Avoid global variables in scripts
    Enable = $true

    # Rule: PSAvoidUsingPositionalParameters
    # Desc: Use named parameters instead of positional
    Enable = $true

    # Rule: PSProvideCommentHelp
    # Desc: Include comment-based help for all functions
    Enable = $true

    # Exclude rules for test files
    ExcludeRules = @(
        'PSAvoidUsingWriteHost'
    )
}
