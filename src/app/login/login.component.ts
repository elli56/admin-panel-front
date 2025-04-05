import { Component } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { AuthService } from '../auth.service';

@Component({
    selector: 'app-login',
    templateUrl: './login.component.html',
    styleUrls: ['./login.component.scss']
})
export class LoginComponent {
    loginForm: FormGroup;

    constructor(private fb: FormBuilder, private authService: AuthService) {
      this.loginForm = this.fb.group({
        email: [''],
        password: ['']
      });
    }

    onSubmit() {
      this.authService.login(this.loginForm.value).subscribe();
    }
}
