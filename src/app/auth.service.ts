import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { BehaviorSubject, Observable } from 'rxjs';
import { map } from 'rxjs/operators';

@Injectable({
    providedIn: 'root'
})
export class AuthService {
    private loggedIn = new BehaviorSubject<boolean>(false);

    get isLoggedIn() {
        return this.loggedIn.asObservable();
    }

    constructor(private http: HttpClient, private router: Router) {}

    login(user: { email: string, password: string }): Observable<any> {
        return this.http.post('/api/login', user).pipe(
            map((response: any) => {
            if (response.token) {
                localStorage.setItem('token', response.token);
                this.loggedIn.next(true);
                this.router.navigate(['/dashboard']);
            }

            return response;
            })
        );
    }

    register(user: { email: string, password: string }): Observable<any> {
        return this.http.post('/api/register', user);
    }

    logout() {
        localStorage.removeItem('token');
        this.loggedIn.next(false);
        this.router.navigate(['/login']);
    }

    getToken() {
        return localStorage.getItem('token');
    }
}
