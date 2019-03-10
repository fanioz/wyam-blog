Write-Host "Cloning existing GitHub Pages branch"

git clone https://${env:githubusername}:$(githubaccesstoken)@github.com/${env:githubusername}/${env:repositoryname}.git --branch=master $(System.DefaultWorkingDirectory)\master --quiet

if ($lastexitcode -gt 0)
{
    Write-Host "##vso[task.logissue type=error;]Unable to clone repository - check username, access token and repository name. Error code $lastexitcode"
    [Environment]::Exit(1)
}

#$to = "$(System.DefaultWorkingDirectory)\master"

Write-Host "Copying new documentation into branch"

Write-Host $env:docPath

Copy-Item ${env:docPath} $(System.DefaultWorkingDirectory)\master -recurse -Force

Write-Host "Committing the GitHub Pages Branch"

cd $(System.DefaultWorkingDirectory)\master
git config core.autocrlf false
git config user.email ${env:githubemail}
git config user.name ${env:githubusername}
git add *
git status
git commit -m ${env:commitMessage}

if ($lastexitcode -gt 0)
{
    Write-Host "##vso[task.logissue type=error;]Error committing - see earlier log, error code $lastexitcode"
    [Environment]::Exit(1)
}

git push

if ($lastexitcode -gt 0)
{
    Write-Host "##vso[task.logissue type=error;]Error pushing to master branch, probably an incorrect Personal Access Token, error code $lastexitcode"
    [Environment]::Exit(1)
}

# # Get inputs.
# $githubaccesstoken = $(githubaccesstoken)

# $docPath = $env:docPath
# $githubusername = $env:githubusername
# $githubemail = $env:githubemail    
# $repositoryname = env:repositoryname
# $commitMessage = env:commitmessage

#     $defaultWorkingDirectory = Get-VstsTaskVariable -Name 'System.DefaultWorkingDirectory'    
    
#     Write-Host "Cloning existing GitHub Pages branch"

#     git clone https://${githubusername}:$githubaccesstoken@github.com/$githubusername/$repositoryname.git --branch=master $defaultWorkingDirectory\master --quiet
    
#     if ($lastexitcode -gt 0)
#     {
#         Write-Host "##vso[task.logissue type=error;]Unable to clone repository - check username, access token and repository name. Error code $lastexitcode"
#         [Environment]::Exit(1)
#     }
    
#     $to = "$defaultWorkingDirectory\master"

#     Write-Host "Copying new documentation into branch"

#     Copy-Item $docPath $to -recurse -Force

#     Write-Host "Committing the GitHub Pages Branch"

#     cd $defaultWorkingDirectory\ghpages
#     git config core.autocrlf false
#     git config user.email $githubemail
#     git config user.name $githubusername
#     git add *
#     git commit -m $commitMessage

#     if ($lastexitcode -gt 0)
#     {
#         Write-Host "##vso[task.logissue type=error;]Error committing - see earlier log, error code $lastexitcode"
#         [Environment]::Exit(1)
#     }

#     git push

#     if ($lastexitcode -gt 0)
#     {
#         Write-Host "##vso[task.logissue type=error;]Error pushing to gh-pages branch, probably an incorrect Personal Access Token, error code $lastexitcode"
#         [Environment]::Exit(1)
#     }