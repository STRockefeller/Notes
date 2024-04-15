import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'Console',
    component: () => import('./../components/Content/Console.vue')
  },
  {
    path: '/console',
    name: 'Console',
    component: () => import('./../components/Content/Console.vue')
  },
  {
    path: '/configuration',
    name: 'Configuration',
    component: () => import('./../components/Content/Configuration.vue')
  },
  {
    path: '/dependencies',
    name: 'Dependencies',
    component: () => import('./../components/Content/Dependencies.vue')
  },
  {
    path: '/plugins',
    name: 'Plugins',
    component: () => import('./../components/Content/Plugins.vue')
  },
  {
    path: '/tasks',
    name: 'Tasks',
    component: () => import('./../components/Content/Tasks.vue')
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
