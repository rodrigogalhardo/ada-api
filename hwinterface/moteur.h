#ifndef __ASSERV_MOTEUR_H__
#define __ASSERV_MOTEUR_H__

typedef struct {
    // Variables d'�tat
    long double i;      // Intensit� (A)
    long double w;      // Vitesse angulaire du rotor, avant r�ducteur (rad/s)
    long double angle;  // Angle du moteur : int�grale de w, la vitesse angulaire (rad)
    long double dist;   // Distance lin�aire parcourue par cette roue du robot (m)
    
    // Param�tres du moteur (on trouve leur valeur dans sa datasheet)
    long double B;      // Coefficient de frottement / Damping ratio (N.m.s)
    long double R;      // R�sistance du moteur (ohms)
    long double L;      // Inductance du moteur (Henry)
    long double J;      // Moment d'inertie du moteur + charge (kg.m^2)
    long double K;      // Constante �lectromotrice du moteur (Ke=Ki, en N.m/A)
    long double n;      // Coefficient de r�duction du r�ducteur (>1)
    
    // Param�tres des roues
    long double r;      // Diam�tre des roues du robot (m)
    
    // Param�tres du pont en H
    long double Umax;   // Tension maximale appliqu�e au moteur
    long double Umin;   // Tension minimale appliqu�e au moteur (0 ou -12)
    long double U;      // Tension actuelle appliqu�e au moteur

    // Param�tres de l'encodeur
    int tics;           // nombre de tics par tour
    
    // Variables auxilliaires, pour acc�l�rer les calculs...
    // Pour l'ordre 2 :
    long double M11, M12, M21, M22;
    // Pour l'ordre 1 :
    long double N1, N2;

    // La plus petite des constantes de temps du moteur, divis�e par 10
    long double time_const;

    // Une cha�ne d'itentification du moteur, pour aider le debug
    char * name;

    // L'ordre du mod�le utilis� pour le moteur (1 ou 2)
    // Le mod�le d'ordre 1 n�glige l'inductance. On n'a plus que la constante m�canique,
    // ce qui permet de ne faire les mise � jour que plus rarement, et acc�l�rer les simulations.
    // Attention : si on change l'ordre du mod�le en cours de simulation, les r�sultats sont
    //             impr�dictibles !
    int ordre;
    
} motor_t;

typedef struct {
    // Variables d'�tat
    long double theta;  // Cap du robot (rad)
    long double x, y;   // Position du robot (m)

    // Les deux moteurs / roues
    motor_t mg, md;     // moteur gauche, moteur droit

    // Param�tres structurels
    long double D;      // Distance entre les roues du robot

} robot_t;


typedef struct {
    char* name;
    double J;
    double B;
    double K;
    double R;
    double L;
    double n;
} mot_params_t;

extern robot_t robot;
extern mot_params_t parm[];
extern int parm_num_g;
extern int parm_num_d;

void init_robot_state(robot_t *robot, long double D);
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
                      long double tics);

void update_robot_state(robot_t *robot);
//void update_motor_state(motor_t *m, long double dt, int dir, int enable);
void update_motor_state(motor_t *m, long double dt, int cmd);
void init_matrice(motor_t *m);
void init_robot(void);
unsigned char get_encodeur(motor_t *m);
long get_tics(motor_t *m);
double get_speed(motor_t *m, double dt);

#endif
