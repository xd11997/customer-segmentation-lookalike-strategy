import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import MiniBatchKMeans, KMeans
from sklearn.metrics import silhouette_score
import matplotlib.pyplot as plt

file = 'outputs_user_analytics.csv'
df = pd.read_csv(file)
df = df[df['cross_purchase_flag'] == 1]
df = df.drop(columns=['user_id', 'cross_purchase_flag', 'feature_date'])

print(df.info())

scaler = StandardScaler()
df_scaled = pd.DataFrame(scaler.fit_transform(df), columns=df.columns)

# k_list = range(2, 9)
# silhouette_scores = []
# intertias = []
# for k in k_list:
#     print(f"Clustering with k={k}...")
#     kmeans = MiniBatchKMeans(n_clusters=k, random_state=42, batch_size=10000, n_init=3)
#     cluster_labels = kmeans.fit_predict(df_scaled)
#     silhouette_avg = silhouette_score(df_scaled, cluster_labels, sample_size=10000, random_state=42)
#     silhouette_scores.append(silhouette_avg)
#     intertias.append(kmeans.inertia_)
# print("Silhouette Scores for different k values:")
# for k, score in zip(k_list, silhouette_scores):
#     print(f"k={k}: Silhouette Score={score:.4f}")
# print("Intertias for different k values:")
# for k, inertia in zip(k_list, intertias):
#     print(f"k={k}: Inertia={inertia:.4f}")
# plt.figure(figsize=(10, 6))
# plt.plot(k_list, silhouette_scores, marker='o')
# plt.title('Silhouette Scores for Different k Values')
# plt.xlabel('Number of Clusters (k)')
# plt.ylabel('Silhouette Score')
# plt.xticks(k_list)
# plt.show()
# plt.figure(figsize=(10, 6))
# plt.plot(k_list, intertias, marker='o')
# plt.title('Inertia for Different k Values')
# plt.xlabel('Number of Clusters (k)')
# plt.ylabel('Inertia')
# plt.xticks(k_list)
# plt.show()

k = 3
kmeans = MiniBatchKMeans(
    n_clusters=3,
    random_state=42,
    batch_size=10000,
    n_init=10
)

df['cluster'] = kmeans.fit_predict(df_scaled)

profile_z = (
    df.groupby('cluster')[df_scaled.columns]
      .mean()
)

profile_z = (
    profile_z - profile_z.mean()
) / profile_z.std()

print(df['cluster'].value_counts())

profile_z_table = profile_z.T.round(2)
profile_z_table.to_csv(
    "cluster_profile_z.csv",
    index=True
)

df.to_csv('user_analytics_with_clusters.csv', index=False)
