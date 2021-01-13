#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define READ_END    0    /* index pipe extremo lectura */
#define WRITE_END   1    /* index pipe extremo escritura */


#define STDIN		0
#define STDOUT		1
#define STDERR		2

typedef struct s_pipe {
    int nb_args;
    char **args;
    pid_t pid;
    int fd[2];
}       t_pipe;

typedef struct s_pipes {
    int nb_pipes;
    t_pipe  *pipe;
}       t_pipes;

int ft_strlen(char *str){
    int i;
    i=0;
    while(str[i])
        i++;
    return(i);
}

char *ft_strdup(char *src){
    int i;
    char *dst;

    if (!src)
        return(NULL);
    if (!(dst = malloc((ft_strlen(src)+1))))
        return(NULL);
    i = 0;
    while(src[i]){
        dst[i]=src[i];
        i++;
    }
    dst[i]=0;
    return(dst);
}
//numero de pipes desde posicion i;
int ft_nbpipes(int i, char **str){
    int c;
    c = 0;
    while (str[i] && strcmp(str[i],";")){
        if (!strcmp(str[i],"|"))
            c++;
        i++;
    }
    return(c+1); //numero de pipes
}
//numero de arg en una pipe desde posicion i;
int ft_nbargs(int i, char **str){
    int c;
    c = 0;
    while (str[i] && strcmp(str[i],"|") && strcmp(str[i],";")){
        i++;
        c++;
    }
    return(c); //numero de pipes
}

int main(int nargv, char **argv, char **env)
{
    int     cont;
    int     pipecont;
    int     argu;
    t_pipes *pipes;
    int		status;
    int     ret;
    int     i;
    int     j;

    //PARSING
    cont = 1; //contador principal
    while (cont < nargv){
            pipes = malloc(sizeof (t_pipes));
            pipes->nb_pipes = ft_nbpipes(cont, argv); 
            pipes->pipe = malloc(sizeof (t_pipe) * pipes->nb_pipes);
            pipecont = 0;
            while (pipecont < pipes->nb_pipes){
                pipes->pipe[pipecont].nb_args = ft_nbargs(cont,argv);
                pipes->pipe[pipecont].args = malloc(sizeof (char*) * pipes->pipe[pipecont].nb_args + 1);
                argu = 0;
                while (argu < pipes->pipe[pipecont].nb_args ){
                    pipes->pipe[pipecont].args[argu] = ft_strdup(argv[cont]);
                    cont++;
                    argu++;
                }
                pipes->pipe[pipecont].args[argu] = 0;
                //if (cont < nargv)
                      cont = cont + 1;
                pipecont++;
            }
            ///
            pipecont = 0;
            while(pipecont < pipes->nb_pipes){
                if (strcmp("cd", pipes->pipe[pipecont].args[0]) == 0) // SI ES CD
                {
                    ret = EXIT_SUCCESS;
                    if (pipes->pipe[pipecont].nb_args < 2) //solo cd
                    {
                        write(STDERR, "error: cd: bad arguments\n", ft_strlen("error: cd: bad arguments\n"));
                        ret = EXIT_FAILURE;
                    }
                    else if (chdir(pipes->pipe[pipecont].args[1])) //
                    {
                        write(STDERR, "error: cd: cannot change directory to ", ft_strlen("error: cd: cannot change directory to "));
                        write(STDERR, pipes->pipe[pipecont].args[1], ft_strlen(pipes->pipe[pipecont].args[1]));
                        write(STDERR, "\n", 1);
                        ret = EXIT_FAILURE;
                    }
                }    
                else ////PIPES
                { 
                            ret = EXIT_FAILURE;
                            pipe(pipes->pipe[pipecont].fd);
                            pipes->pipe[pipecont].pid= fork();
                            if (pipes->pipe[pipecont].pid < 0)
                            {
                                write(STDERR, "error: fatal\n", ft_strlen("error: fatal\n"));
                                exit(EXIT_FAILURE);
                            }
                            else if (pipes->pipe[pipecont].pid  == 0) //child
                            {
                                close(pipes->pipe[pipecont].fd[READ_END]);
                                if (pipecont < pipes->nb_pipes-1)
                                    dup2(pipes->pipe[pipecont].fd[WRITE_END], STDOUT); //vuelca la salida estandar en la entrada del pipe   
                                if (pipecont > 0)   //si hay un pipe anterior 
                                    dup2(pipes->pipe[pipecont-1].fd[READ_END], STDIN);    //REDIRIGE LA SALIDA DEL PIPE ANTERIOR (si hay) AL ESTANDAR INPUT        
                                if ((ret = execve(pipes->pipe[pipecont].args[0], pipes->pipe[pipecont].args, env)) < 0)
                                {
                                    write(STDERR, "error: cannot execute ", ft_strlen("error: cannot execute "));
                                    write(STDERR, pipes->pipe[pipecont].args[0], ft_strlen(pipes->pipe[pipecont].args[0]));
                                    write(STDERR, "\n", 1);
                                }
                                exit(ret);
                            }
                            else  //father
                            {
                                close(pipes->pipe[pipecont].fd[WRITE_END]); 
                                waitpid(pipes->pipe[pipecont].pid , &status, 0);  
                                if (pipecont > 0)
                                        close(pipes->pipe[pipecont-1].fd[READ_END]);       
                                if (pipecont == pipes->nb_pipes-1)
                                        close(pipes->pipe[pipecont].fd[READ_END]);     
                                if (WIFEXITED(status))
                                        ret = WEXITSTATUS(status);
                            }
                }
                pipecont++;
            }
            j = -1;         //libero la estructura
            while (++j < pipes->nb_pipes)
            {
                i = -1;
                while(pipes->pipe[j].args[++i])
                    free(pipes->pipe[j].args[i]);
                free(pipes->pipe[j].args);
            }
            free(pipes->pipe);
            free(pipes);
    }
    system("leaks a.out");
    return(ret);
}