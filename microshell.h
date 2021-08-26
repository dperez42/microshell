/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   microshell.h                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dperez-z <dperez-z@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/08/26 12:32:45 by dperez-z          #+#    #+#             */
/*   Updated: 2021/08/26 12:34:24 by dperez-z         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef MICROSHELL_H
# define MICROSHELL_H 

# include <unistd.h>
# include <stdio.h>
# include <stdlib.h>
# include <string.h>

# define STDIN		0
# define STDOUT		1
# define STDERR		2

# define END		0
# define S_COLON	1
# define PIPE		2

typedef struct s_cmds
{
    char            **args;
    char            type;
    int             len;
    int             fds[2];
    struct s_cmds   *next;
    struct s_cmds   *prev;
}					t_cmds;

#endif