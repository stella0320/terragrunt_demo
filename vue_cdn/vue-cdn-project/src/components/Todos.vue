<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'

type ApiTodoItem = {
  createdAt: string
  message: string
  pk: string
  done: boolean
  sk: string
}

// const API_BASE = 'https://8kbpkvwc6c.execute-api.ap-northeast-1.amazonaws.com'
const API_BASE = ''
const STAGE = 'dev'

const userId = ref('u001')
const newTodo = ref('')
const todos = ref<ApiTodoItem[]>([])
const isLoading = ref(false)
const errorMessage = ref<string | null>(null)

const pendingCount = computed(() => todos.value.filter((t) => !t.done).length)

function apiUrl() {
  return `${API_BASE}/${STAGE}/api/todos`
}

async function fetchTodos() {
  isLoading.value = true
  errorMessage.value = null

  try {
    const url = new URL(apiUrl(), window.location.origin)
    url.searchParams.set('userId', userId.value)
    console.log('Fetching todos from', url.toString())
    const res = await fetch(url.toString(), {
      method: 'GET',
      headers: { Accept: 'application/json' },
    })

    if (!res.ok) {
      const text = await res.text().catch(() => '')
      throw new Error(`${res.status} ${res.statusText}${text ? ` - ${text}` : ''}`)
    }

    const data = (await res.json()) as ApiTodoItem[]
    todos.value = Array.isArray(data) ? data : []
  } catch (err) {
    errorMessage.value = err instanceof Error ? err.message : String(err)
  } finally {
    isLoading.value = false
  }
}

async function addTodo() {
  const message = newTodo.value.trim()
  if (!message) return

  isLoading.value = true
  errorMessage.value = null

  try {
    const res = await fetch(apiUrl(), {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
      body: JSON.stringify({ userId: userId.value, message }),
    })

    if (!res.ok) {
      const text = await res.text().catch(() => '')
      throw new Error(`${res.status} ${res.statusText}${text ? ` - ${text}` : ''}`)
    }

    const created = (await res.json()) as ApiTodoItem
    todos.value = [created, ...todos.value]
    newTodo.value = ''
  } catch (err) {
    errorMessage.value = err instanceof Error ? err.message : String(err)
  } finally {
    isLoading.value = false
  }
}

function messageIdFromSk(sk: string) {
  const prefix = 'MSG#'
  return sk.startsWith(prefix) ? sk.slice(prefix.length) : sk
}

async function removeTodo(todo: ApiTodoItem) {
  // Expected route (depending on API Gateway config): DELETE /{stage}/api/todos/{userId}/{messageId}
  const messageId = messageIdFromSk(todo.sk)

  isLoading.value = true
  errorMessage.value = null

  try {
    const res = await fetch(`${apiUrl()}/${encodeURIComponent(userId.value)}/${encodeURIComponent(messageId)}`, {
      method: 'DELETE',
      headers: { Accept: 'application/json' },
    })

    if (!res.ok) {
      const text = await res.text().catch(() => '')
      throw new Error(`${res.status} ${res.statusText}${text ? ` - ${text}` : ''}`)
    }

    todos.value = todos.value.filter((t) => t.sk !== todo.sk)
  } catch (err) {
    errorMessage.value = err instanceof Error ? err.message : String(err)
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  void fetchTodos()
})
</script>

<template>
  <div class="page">
    <section class="card" aria-label="Todo App">
      <h1 class="title">Todo App</h1>

      <div class="composer">
        <input
          v-model="newTodo"
          class="input"
          type="text"
          placeholder="Add your new todo"
          :disabled="isLoading"
          @keyup.enter="addTodo"
          aria-label="Add your new todo"
        />
        <button class="add" type="button" :disabled="isLoading" @click="addTodo" aria-label="Add todo">
          <i class="fa-solid fa-plus" aria-hidden="true"></i>
        </button>
      </div>

      <p v-if="errorMessage" class="error" role="alert">{{ errorMessage }}</p>

      <ul class="list" aria-label="Todo list">
        <li v-if="isLoading && todos.length === 0" class="empty">Loading…</li>
        <li v-else-if="todos.length === 0" class="empty">No todos yet</li>

        <li v-for="todo in todos" :key="todo.sk" class="item">
          <span class="text">{{ todo.message }}</span>
          <button class="trash" type="button" :disabled="isLoading" @click="removeTodo(todo)" aria-label="Delete todo">
            <i class="fa-solid fa-trash" aria-hidden="true"></i>
          </button>
        </li>
      </ul>

      <div class="footer">
        <p class="pending">You have {{ pendingCount }} pending tasks</p>
      </div>
    </section>
  </div>
</template>

<style scoped>
.page {
  min-height: 100vh;
  display: grid;
  place-items: center;
  padding: 24px;
  /* background: #56d8d8; */
}

.card {
  width: min(420px, 100%);
  background: #fff;
  border-radius: 8px;
  padding: 28px;
  box-shadow: 0 18px 45px rgba(0, 0, 0, 0.18);
}

.title {
  margin: 0 0 18px;
  font-size: 40px;
  font-weight: 800;
  letter-spacing: -0.02em;
  color: #111827;
}

.composer {
  display: grid;
  grid-template-columns: 1fr 56px;
  gap: 14px;
  margin-bottom: 18px;
}

.input {
  height: 56px;
  border: 2px solid #e5e7eb;
  border-radius: 6px;
  padding: 0 16px;
  font-size: 16px;
  outline: none;
}

.input:focus {
  border-color: #a78bfa;
  box-shadow: 0 0 0 4px rgba(167, 139, 250, 0.22);
}

.input:disabled {
  background: #f9fafb;
  color: #6b7280;
}

.add {
  height: 56px;
  width: 56px;
  border: 0;
  border-radius: 6px;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 34px;
  line-height: 1;
  color: #fff;
  background: #7c3aed;
  cursor: pointer;
}

.add:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.add:active {
  transform: translateY(1px);
}

.error {
  margin: 0 0 14px;
  padding: 10px 12px;
  border-radius: 6px;
  background: #fee2e2;
  color: #991b1b;
  font-weight: 600;
}

.list {
  list-style: none;
  padding: 0;
  margin: 0 0 20px;
  display: grid;
  gap: 12px;
}

.empty {
  background: #f3f4f6;
  border-radius: 6px;
  padding: 14px;
  color: #6b7280;
  font-weight: 600;
}

.item {
  display: grid;
  grid-template-columns: 1fr 52px;
  align-items: center;
  gap: 10px;
  background: #f3f4f6;
  border-radius: 6px;
  padding: 14px 14px;
}

.text {
  color: #374151;
  font-size: 16px;
  font-weight: 600;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.trash {
  width: 44px;
  height: 44px;
  border: 0;
  border-radius: 6px;
  padding: 0;
  background: #ef4444;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.trash:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.trash i {
  display: block;
  font-size: 18px;
  line-height: 1;
}

.add i {
  display: block;
  font-size: 22px;
  line-height: 1;
}

.footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.pending {
  margin: 0;
  font-size: 16px;
  color: #374151;
}

.clear {
  height: 44px;
  padding: 0 16px;
  border: 0;
  border-radius: 6px;
  background: #7c3aed;
  color: #fff;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
}

.clear:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
