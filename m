Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4840219CC3C
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727102877; cv=none; b=lW9jczjN12MtiPiUlU9XPTBxwIGkgIX0Nw1wONUZjuGngdrpYwAfIEy6lMrRLIc7XE48vTDLu4YdwYMep70IpXsjuRXJnlrhTDHj7CjbO0zQIZg71oRX8na61qaS/FuEVmPKwSMHJ5QywDsPLHOKY/eXMXu3PkYw/PwyWlxheTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727102877; c=relaxed/simple;
	bh=Bk0fNQRsh28mlTF+N79aeZ/0DJFr8w85c0CjH9t0gtI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P+vHQ8ZAiED/XGvHUhEgInOm+dyDgy2b3A2iJDlE3JgmVr1H3Zr6J2kfZdzqgKc9NG3DK2Gxw5TpgWaXdXQ578lerndlYBamsOeMA1B/rU9I9glwE/TysVDnNudCWURa9+TfQz8hSupOM2rmVa9lZO0e1swNpElIg0uNfgERkGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KXlsyNKS; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KXlsyNKS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727102871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wxyecHP0DQb9yEgGdekn4EqQ2Tgs0JnWo2dsEC0la5w=;
	b=KXlsyNKSZZE8+Cm9rTlGTCi5mj1z84IPRzzqcxCmh2+/xQALL0hzKtFflItnWmhiAVPzMJ
	ASjufaJkbsoYQgv4Gw2VHhQB5+5BQGI4GIHZbLS5F2U0MTp3h0SYq4FVHQWVIjhE5nioKL
	i/8dvVUQ/k5hYpi9Pg4hgejh+G9ILfk=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: Use FOREACH_ACL_ENTRY() macro to iterate over acl entries
Date: Mon, 23 Sep 2024 16:44:53 +0200
Message-ID: <20240923144452.233096-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use the existing FOREACH_ACL_ENTRY() macro to iterate over POSIX acl
entries and remove the custom acl_for_each_entry() macro.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/bcachefs/acl.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/acl.c b/fs/bcachefs/acl.c
index 1def61875a6f..56b160e71a53 100644
--- a/fs/bcachefs/acl.c
+++ b/fs/bcachefs/acl.c
@@ -184,11 +184,6 @@ static struct posix_acl *bch2_acl_from_disk(struct btree_trans *trans,
 	return ERR_PTR(-EINVAL);
 }
 
-#define acl_for_each_entry(acl, acl_e)			\
-	for (acl_e = acl->a_entries;			\
-	     acl_e < acl->a_entries + acl->a_count;	\
-	     acl_e++)
-
 /*
  * Convert from in-memory to filesystem representation.
  */
@@ -199,11 +194,11 @@ bch2_acl_to_xattr(struct btree_trans *trans,
 {
 	struct bkey_i_xattr *xattr;
 	bch_acl_header *acl_header;
-	const struct posix_acl_entry *acl_e;
+	const struct posix_acl_entry *acl_e, *pe;
 	void *outptr;
 	unsigned nr_short = 0, nr_long = 0, acl_len, u64s;
 
-	acl_for_each_entry(acl, acl_e) {
+	FOREACH_ACL_ENTRY(acl_e, acl, pe) {
 		switch (acl_e->e_tag) {
 		case ACL_USER:
 		case ACL_GROUP:
@@ -241,7 +236,7 @@ bch2_acl_to_xattr(struct btree_trans *trans,
 
 	outptr = (void *) acl_header + sizeof(*acl_header);
 
-	acl_for_each_entry(acl, acl_e) {
+	FOREACH_ACL_ENTRY(acl_e, acl, pe) {
 		bch_acl_entry *entry = outptr;
 
 		entry->e_tag = cpu_to_le16(acl_e->e_tag);
-- 
2.46.1

