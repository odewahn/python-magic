
# Version Control and Source Code Management

Version control is how you can ensure that you can recall older versions of a file when you need them. A version control system records changes to one or more files and lets you easily recall any older version you want.

In the previous chapter, you learned about the concept of Infrastructure as Code. A Version Control system can act as the foundation for Infrastructure as Code. Everything you do in your infrastructure, you can capture it in scripts, configuration files and definition files and check them into a VC such as Git.

In this chapter, I explain the essentials of Git, which is the most popular version control system today.

## Revision Control and Infrastructure Management
One might wonder how revision control, which has traditionally been used for source code management, helps with infrastructure management. System administrators can use revision control in exactly the same way as developers do!

For example, you can use Git for storing the BIND configuration you use in your environment. Similarly, you can store the configuration details for software such as Postfix, iptables, Hadoop and Mysql, etc in revision control.

NOTE: Configuration management tools such as Puppet and Chef integrate well with Git

You can change all your infrastructure related scripts and configuration files in a VCS. When a system administrator wants to make changes, he/she checks the necessary files out of the VCS, makes their changes, and commits them back into the VCS.

These committed changes are then available for application to the infrastructure. If you’re using a change management pipeline (see Chapter 11), the changes are automatically applied to and tested in a test environment. If different members of the admin team are making incompatible configuration changes, the VCS will force you to reconcile the differences by showing up the changes as being in conflict with each other.

In this context, it’s interesting to know that a lot of open source software projects such as the Linux kernel, OpenStack, and Yum, store their source code in Git.

## Our First Foray into the World of Git
In this section, I get your feet wet, by providing a whirlwind tour through basic Git operations. This way, you get a good flavor of Git commands and Git operations and what they do. I’ll follow this section up with a brief explanation of Git’s fundamental features: branching, committing, and cloning.

Before we start, let's switch over to a new working direcory:

<span id="makeDirectory"/>


```bash
cd /tmp
mkdir git-test
cd git-test
```

    

We'll also need to provide some configuration information to (among other thing) identify ourselves in the commit history as we make changes:

<span id="configureGit"/>


```bash
git config --global user.email "odewahn@oreilly.com"
git config --global user.name "Andrew Odewahn"
```

    

From this directory, create a local git repository with the git init command:

<span id="initGit"/>


```bash
git init
```

    Initialized empty Git repository in /tmp/git-test/.git/


Let’s create a simple Python file named test.py with the following content:

<span id="createHelloGitPy"/>


```bash
echo "print('Hello Git')" > test.py
```

    

Just to make sure it worked, let's run it and confirm we get what we expect:


```bash
python test.py
```

    Hello Git


Let’s add this new Python file to the git repository I initialized earlier.

<span id="addTestPy"/>


```bash
git add test.py
```

    

Check the status of your new repository with the git status command:

<span id="checkStatus"/>


```bash
git status
```

    On branch master
    
    Initial commit
    
    Changes to be committed:
      (use "git rm --cached <file>..." to unstage)
    
    	new file:   test.py
    


The output of the git status command reveals that there are “changes to be committed”. Our new file test.py is sure part of the local repository but not yet committed. Why don’t we commit the changes and see what happens?

<span id="firstCommit"/>


```bash
git commit -m "simple print program"
```

    [master (root-commit) 7661e7a] simple print program
     1 file changed, 1 insertion(+)
     create mode 100644 test.py


Check the current status of the git local repository.


```bash
git status
```

    On branch master
    nothing to commit, working directory clean


OK! My test.py file is safely tucked away now in my local repository. Just for the heck of it, I make a change in the test.py file and see what git says.

<span id="helloWorldPy"/>


```bash
echo "print('Hello World')" > test.py
```

    


```bash
git status
```

    On branch master
    Changes not staged for commit:
      (use "git add <file>..." to update what will be committed)
      (use "git checkout -- <file>..." to discard changes in working directory)
    
    	modified:   test.py
    
    no changes added to commit (use "git add" and/or "git commit -a")


I can execute the diff command to see the differences between the original test.py file and the modified version of that file. The git diff command shows the changes since the last commit of the test.py file:

<span id="gitDiff"/>


```bash
git diff
```

    diff --git a/test.py b/test.py
    index d7f199c..df1dc68 100644
    --- a/test.py
    +++ b/test.py
    @@ -1 +1 @@
    -print('Hello Git')
    +print('Hello World')


In order to commit the changes I’ve made to the test.py file, I need to first add the modified test.py file:


```bash
git add test.py
```

    

Once I add the new test.py file, I commit the change:

<span id="secondCommit"/>


```bash
git commit -m "my first change"
```

    [master 1598fc3] my first change
     1 file changed, 1 insertion(+), 1 deletion(-)


The git log command will let you see all the changes you’ve made to the test.py file.

<span id="gitLog"/>


```bash
git log test.py
```

    commit 1598fc3d8df9bf19913bc14960aa76bd4fe4cc2a
    Author: Andrew Odewahn <odewahn@oreilly.com>
    Date:   Sun Sep 25 21:44:23 2016 +0000
    
        my first change
    
    commit 7661e7ac7dd51d662a6839783e754e96a18fcd01
    Author: Andrew Odewahn <odewahn@oreilly.com>
    Date:   Sun Sep 25 21:32:15 2016 +0000
    
        simple print program


<span id="theEnd"/>
