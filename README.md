# hackaton

*********************   micky   *************************************************

micky@plimbaricison:~$ git --git-dir=/media/micky/WORK/GIT-REPOSITORY/ clone https://github.com/madmaggie/hackaton.git
Cloning into 'hackaton'...
remote: Counting objects: 3, done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), done.
Checking connectivity... done.


deci ok, dar nu m-am prins ce face --git-dir ca tot in directorul curent a clonat..


micky@plimbaricison:~$ git checkout master (aici mi-a dat eroare, m-am prins mai tarziu k nu eram in alt folder :D)
are sens sa dau ckheckout imediat dupa clone? dupa clone aveam deja local ce era si remote


usefull (for me at least:D):

--------------------------------------

links

http://rogerdudler.github.io/git-guide/
http://ndpsoftware.com/git-cheatsheet.html#loc=remote_repo;


--------------------------------------

Remove directory from git and local


git rm -r one-of-the-directories
git commit -m "Remove duplicated directory"
git push origin master



Remove directory from git but NOT local

git rm -r --cached myFolderone-of-the-directories
git commit -m "Remove duplicated directory"
git push origin master


sau dc am sters manual un fisier/folder local  si vreau sa aplic modificarea si remote:

git add --all .
git commit -m "Remove duplicated directory"
git push origin master

--all -> pt k altfel ignora ce e sters (default behaviour este ceva gen --ignore-removed)
(ceva de genu asta mi-a explicat git knd am dat "git add .", dar nu mai am explicatia exacta)



--------------------------------------

git status -> track modifications



--------------------------------------

(asta l-am pus aici k e alt msg de la git - cum a fost si cel pt --all,
 si dc pe ala nu-l mai am, am zis macar asta sa-l pastrez:D)

micky@plimbaricison:/media/micky/WORK/GIT-REPOSITORY/hackaton$ git push
warning: push.default is unset; its implicit value is changing in
Git 2.0 from 'matching' to 'simple'. To squelch this message
and maintain the current behavior after the default changes, use:

  git config --global push.default matching

To squelch this message and adopt the new behavior now, use:

  git config --global push.default simple

When push.default is set to 'matching', git will push local branches
to the remote branches that already exist with the same name.

In Git 2.0, Git will default to the more conservative 'simple'
behavior, which only pushes the current branch to the corresponding
remote branch that 'git pull' uses to update the current branch.

See 'git help config' and search for 'push.default' for further information.
(the 'simple' mode was introduced in Git 1.7.11. Use the similar mode
'current' instead of 'simple' if you sometimes use older versions of Git)



*********************   end micky   ********************************************** 