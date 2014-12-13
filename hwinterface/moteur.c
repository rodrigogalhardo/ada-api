--------------------------------------------------------------------------------
--
--Copyright 2014 - Julien Brette
--
--This program is free software: you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU General Public License
--along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
--------------------------------------------------------------------------------

/*------------------------------------------------------------------------------
--
--Copyright 2014 - Julien Brette
--
--This program is free software: you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU General Public License
--along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
------------------------------------------------------------------------------*/

//#include <stdlib.h>
#include <stdint.h>
//#include <stdio.h>
#include <math.h>
#include <string.h>
#include "moteur.h"

#define maxl(a,b) ((a<b) ? b : a)
#define minl(a,b) ((a<b) ? a : b)

robot_t robot;

void init_matrice(motor_t *m) {
    m->M11 = -(m->B)/(m->J);
    m->M12 = (m->K)/(m->J);
    m->M21 = -(m->K)/(m->L);
    m->M22 = -(m->R)/(m->L);
    m->N1 = -(m->B + (m->K)*(m->K)/(m->R))/(m->J);
    m->N2 = (m->K)/((m->R)*(m->J));
}

//void update_motor_state(motor_t *m, long double dt, int dir, int enable) {
void update_motor_state(motor_t *m, long double dt, int cmd) {
    long double new_i, new_w;

    if(m->ordre==0)
    {
        m->w = -m->N2/m->N1*m->U;
    }
    else if(m->ordre==1)
    {
        // Modèle d'ordre 1 : on néglige l'inductance
        // Mise à jour de l'état du moteur *m, avec les paramètres de jusqu'à présent
        m->w = (1+(m->N1)*dt)*(m->w) + (m->N2)*dt*(m->U);
    }
    else
    {
        // Modèle d'ordre 2 : tous les paramètres sont pris en compte
        // Mise à jour de l'état du moteur *m, avec les paramètres de jusqu'à présent
        new_w = (1+(m->M11)*dt)*(m->w) + (m->M12)*dt*(m->i);
        new_i = (m->M21)*dt*(m->w) + (1+(m->M22)*dt)*(m->i) + dt*(m->U)/(m->L);
        
        m->w = new_w;
        m->i = new_i;
    }
        
    m->angle += m->w*dt;
    m->dist = (m->angle)*(m->r)/(m->n);

    // On met à jour les paramètres du moteur (commande)
//    if(enable==0)
//        m->U = 0;
//    else
//        m->U = dir ? m->Umax : m->Umin;
    m->U = m->Umax * (long double)cmd / 4096.0;
}

unsigned char get_encodeur(motor_t *m) {
    long tic;

    tic = ((m->angle/(2*M_PI))*m->tics*4);
    tic = tic % 4;
    return tic;
}

long get_tics(motor_t *m) {
    long tic;

    tic = ((m->angle/(m->n*2*M_PI))*m->tics*4);
//    printf("Angle %Lf => %ld tics\n", m->angle, tic);
    return tic;
}

double get_speed(motor_t *m, double dt) {
    return (m->w/(m->n*2*M_PI))*m->tics*4*dt;
}

void update_robot_state(robot_t *robot) {

    // Distance parcourue à droite (gauche) depuis la dernière mise à jour
    long double dd, dg;
    
    // Distance parcourue à droite (gauche) au dernier appel
    static long double old_dd, old_dg; 

    dd = robot->md.dist - old_dd;
    dg = robot->mg.dist - old_dg;

    // Mise à jour de l'angle du robot
    // On considère que les distances parcourues depuis la denière mise à jour
    // sont petites...
    robot->theta += (dd-dg) / robot->D;

    // Mise à jour de x et y
    robot->x += ((dd+dg)/2.0)*cosl(robot->theta);
    robot->y += ((dd+dg)/2.0)*sinl(robot->theta);

    // Mise à jour des sauvegarde
    old_dd = robot->md.dist;
    old_dg = robot->mg.dist;

//    printf("Robot: %lf %lf\n", (double)dd, (double)dg);
}

void init_motor_state(motor_t *m,
                      int ordre,
                      long double B,
                      long double R,
                      long double L,
                      long double J,
                      long double K,
                      long double n,
                      long double r,
                      long double Umax,
                      long double Umin,
                      long double tics) {

    long double tel, tem;
    
    m->ordre = ordre;
    m->B = B;
    m->R = R;
    m->L = L;
    m->J = J;
    m->K = K;
    m->n = n;
    m->r = r;
    m->Umax = Umax;
    m->Umin = Umin;
    m->tics = tics;

    m->i = 0;
    m->w = 0;
    m->angle = 0;
    m->dist = 0;

    m->U = 0;

    init_matrice(m);

    // Maintenant, on calcule les constantes de temps du moteur
    // On s'arrangera dans la simulation à faire l'update du moteur à un
    // intervalle plus petit que la plus petit des constantes
    tel = (m->L)/(m->R);
    tem = (m->J)*(m->R)/((m->B)+(m->K)*(m->K));

//    printf("%s :\n", m->name);
    if(m->ordre==0) {
    }
    else if(m->ordre==1) {
//        printf("\tconstante électrique ignorée\n");
//        printf("\tconstante mécanique  = %.12Lfs\n",tem);
        m->time_const = tem;
        // on prend quand même une marge sur la constante de temps
        // pour avoir des résultats un peu plus précis
        m->time_const = tem/10;
    }
    else {
//        printf("\tconstante électrique  = %.12Lf\n", tel);
//        printf("\tconstante mécanique  = %.12Lfs\n", tem);
        m->time_const = minl(tel, tem);
    }
}

void init_robot_state(robot_t *robot, long double D) {
    robot->theta = 0;
    robot->x = 0;
    robot->y = 0;
    robot->D = D;

    robot->mg.name = strdup("Moteur gauche");
    robot->md.name = strdup("Moteur droit");
}


mot_params_t parm[] = {
    /*  name              ,      J     ,           B      ,   K    , R   ,  L,    n   */
    {"RE025G_PLG32_12V_36",     0.00022222, 6.694/1000000, 0.0163, 1.34, 0.00012, 36},
    {"RE025G_PLG32_12V_20",     0.0004,     0.00000925,    0.0163, 1.34, 0.00012, 20},
    {"RE025CLL_WGG012_12V_40",  0.0002,     1/1000000,     0.0234, 2.18, 0.00024, 40},
    {"RE025CLL_WGG012_12V_20",  0.0004,     2.044/1000000,  0.0234, 2.18, 0.00024, 20},
    {"RE025CLL_WGG012_12V_15",  0.00053333, 2.044/1000000,  0.0234, 2.18, 0.00024, 15},
    {"RE025CLL_WGG012_12V_10",  0.0008,     2.044/1000000,  0.0234, 2.18, 0.00024, 10},
    {"RE025CLL_PLG26_12V_33",   0.0002424,  4.251/1000000,  0.0234, 2.18, 0.00024, 33},
    {"RE025CLL_PLG26_12V_19",   0.0004210,  4.25/1000000,  0.0234, 2.18, 0.00024, 19},
    {"RE025G_WGG012_12V_40",     0.0002,     3.416/100000,  0.0163, 1.34, 0.00012, 40},
//    {"RE025G_WGG012_12V_20",     0.0004,     3.416/100000,  0.0163, 1.34, 0.00012, 10}
    {"RE025G_WGG012_12V_20",     0.000004,     3.416/100000,  0.0163, 1.34, 0.00012, 10}
};
		
int parm_num_g;
int parm_num_d;

void init_robot(void) {

    long double r, Umax, Umin, tics, D;
    int ordre;

    // Ordre du modèle (1 ou 2)
    ordre = 1;

    // Numéro du moteur dans la liste ci-dessus
    parm_num_g = 9;
    parm_num_d = 9;

    // Paramètres propres au robot
    r = 0.04;
    Umax = 12;
    Umin = -12;
//    tics = 1000*54/63; // Diametre roue motrice: 54mm, roue codeuse: 63mm
//    tics = 5000;
    tics = 500;
    D = 0.3;

    init_robot_state(&robot, D);
    init_motor_state(&robot.md, ordre, parm[parm_num_d].B, parm[parm_num_d].R, parm[parm_num_d].L,
                     parm[parm_num_d].J, parm[parm_num_d].K, parm[parm_num_d].n,
                     r, Umax, Umin, tics);
    init_motor_state(&robot.mg, ordre, parm[parm_num_g].B, parm[parm_num_g].R, parm[parm_num_g].L,
                     parm[parm_num_g].J, parm[parm_num_g].K, parm[parm_num_g].n,
                     r, Umax, Umin, tics);
}

void engine_loop(int16_t* left, int16_t* right, float dt) {
  update_motor_state(&robot.mg, dt, *left);
  update_motor_state(&robot.md, dt, *right);
  update_robot_state(&robot);
  *left = get_tics(&robot.mg);
  *right = get_tics(&robot.md);    
}
