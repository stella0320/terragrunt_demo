import { createRouter, createWebHistory } from 'vue-router'
import Todos from '../components/Todos.vue'
import HelloWorld from '../components/HelloWorld.vue'
import ErrorPage from '../components/ErrorPage.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: HelloWorld },
    { path: '/todos', component: Todos },
    { path: '/error', component: ErrorPage },
    { path: '/:pathMatch(.*)*', redirect: '/error' },
  ],
})

export default router
