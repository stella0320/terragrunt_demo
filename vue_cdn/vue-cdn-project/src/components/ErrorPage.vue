<template>
  <div class="page">
    <section class="card" aria-label="Not Found">
      <h1 class="title">404</h1>
      <p class="subtitle">Page not found</p>
      <RouterLink class="btn" to="/todos">Go to Todos</RouterLink>
    </section>
  </div>
</template>

<style scoped>
.page {
  min-height: 50vh;
  display: grid;
  place-items: center;
  padding: 24px;
  /* background: #56d8d8; */
}

.card {
  width: min(420px, 100%);
  background: #fff;
  border-radius: 10px;
  padding: 28px;
  box-shadow: 0 18px 45px rgba(0, 0, 0, 0.18);
  text-align: center;
}

.title {
  margin: 0;
  font-size: 56px;
  font-weight: 900;
  letter-spacing: -0.03em;
  color: #111827;
}

.subtitle {
  margin: 8px 0 18px;
  font-size: 16px;
  font-weight: 700;
  color: #4b5563;
}

.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 44px;
  padding: 0 16px;
  border-radius: 6px;
  background: #7c3aed;
  color: #fff;
  font-weight: 800;
  text-decoration: none;
}
</style>
