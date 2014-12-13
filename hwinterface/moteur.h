#ifndef __ASSERV_MOTEUR_H__
#define __ASSERV_MOTEUR_H__

typedef struct {
    // Variables d'état
    long double i;      // Intensité (A)
    long double w;      // Vitesse angulaire du rotor, avant réducteur (rad/s)
    long double angle;  // Angle du moteur : intégrale de w, la vitesse angulaire (rad)
    long double dist;   // Distance linéaire parcourue par cette roue du robot (m)
    
    // Paramètres du moteur (on trouve leur valeur dans sa datasheet)
    long double B;      // Coefficient de frottement / Damping ratio (N.m.s)
    long double R;      // Résistance du moteur (ohms)
    long double L;      // Inductance du moteur (Henry)
    long double J;      // Moment d'inertie du moteur + charge (kg.m^2)
    long double K;      // Constante électromotrice du moteur (Ke=Ki, en N.m/A)
    long double n;      // Coefficient de réduction du réducteur (>1)
    
    // Paramètres des roues
    long double r;      // Diamètre des roues du robot (m)
    
    // Paramètres du pont en H
    long double Umax;   // Tension maximale appliquée au moteur
    long double Umin;   // Tension minimale appliquée au moteur (0 ou -12)
    long double U;      // Tension actuelle appliquée au moteur

    // Paramètres de l'encodeur
    int tics;           // nombre de tics par tour
    
    // Variables auxilliaires, pour accélérer les calculs...
    // Pour l'ordre 2 :
    long double M11, M12, M21, M22;
    // Pour l'ordre 1 :
    long double N1, N2;

    // La plus petite des constantes de temps du moteur, divisée par 10
    long double time_const;

    // Une chaîne d'itentification du moteur, pour aider le debug
    char * name;

    // L'ordre du modèle utilisé pour le moteur (1 ou 2)
    // Le modèle d'ordre 1 néglige l'inductance. On n'a plus que la constante mécanique,
    // ce qui permet de ne faire les mise à jour que plus rarement, et accélérer les simulations.
    // Attention : si on change l'ordre du modèle en cours de simulation, les résultats sont
    //             imprédictibles !
    int ordre;
    
} motor_t;

typedef struct {
    // Variables d'état
    long double theta;  // Cap du robot (rad)
    long double x, y;   // Position du robot (m)

    // Les deux moteurs / roues
    motor_t mg, md;     // moteur gauche, moteur droit

    // Paramètres structurels
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
