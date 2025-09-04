Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFD822C355
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756963323; cv=none; b=UaLXWHOdRj97u7SqlK0+hFronuJUgmTOQkGGqjPcq+k1CO80Blr8OgHjK49ZC4alb3iGZVaOhTucgdeU3LY3upi6tJHEckgdxtdtIzW7NVGiEUX1eCGnpqKJOfn8HKrwdewMeTSl4cTy+HhVrBBNx4vqA2kDSaVt1FeFJV3bQnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756963323; c=relaxed/simple;
	bh=BMh3y+iPXkEGYaaW4w3R2OtP5I/+C26Uh+A/Zsch8W0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hQpRZhTw+ALui/786iw6s1578pf31kKJmjCRQJq9stDCMe++991zOCGt/A3euN7a8bwnDIsJc9Vuu4JF6k8xDIhms9mgR3lyqGx1Ahr6f8o4d+ymJ6vcn9NXmCJN7HfId1/PQV6fsZD2eQflRbIBmGgt+eumW9YW1ergMg8FK1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+3giWw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+3giWw9"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4659EC4CEF7;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756963323;
	bh=BMh3y+iPXkEGYaaW4w3R2OtP5I/+C26Uh+A/Zsch8W0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=g+3giWw9hRvVrFJmun6tnDQyb5bFV2pXXX8eAjE7iHcpXRmDYucYaJCinqwsH6NUc
	 va2u3A54cLzBNZTBV+7VtKyf/M7KdyKt/0HV0Qw7gjks7ZMYCuvMD/1aS1takKjcVr
	 b76PQDgne8r+xo7ppSClnxYNvJdj5W0UrTzR3OuAe4UBBqVEioWXMX8lJbEmDff71b
	 d+7wCVxEKT2hFvSgByLF858sBOod5XEamzAItreu5FsTjLWQH2Zibr4fMrNdt1psZI
	 j5oeve8tyygJZfjB74M2CAFa6Q+EjNAkkb27BZqarnV1RkGpF6flPkLrdP8gtKxdZi
	 m6IRK6nhn7gfQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A774CA1015;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 04 Sep 2025 08:20:32 +0300
Subject: [PATCH v3 1/7] bcachefs: Fix missing c->usage updates from early
 recovery
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250904-better-progress-v3-1-6cc4edf543f4@gmail.com>
References: <20250904-better-progress-v3-0-6cc4edf543f4@gmail.com>
In-Reply-To: <20250904-better-progress-v3-0-6cc4edf543f4@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1278; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=362Enryjr7PcDprx4tSSxevQeeNm3RQLlhblMoU/MBg=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWTsVPzxzoXv15EX2omTtz4T52pgSZ7iGlFjlWoz66CuR
 NMvroxdHaUsDGJcDLJiiiwflnz9sybT+o+l0F5DmDmsTCBDGLg4BWAiWhIMfwU+BKzTsdRKjF+/
 RvNy4dwfh7PuGWx+JbP4oZloodl+0y6Gf3oJ2bdPvzp4bIalvssDnvzLYo2ydwUs9IW7nh77aPl
 2JTcA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Make do_bch2_trans_commit_to_journal_replay apply global FS usage
updates stored in trans->fs_usage_delta, too.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/btree_trans_commit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 5fa7f2f9f1e9d0ddd1d4675774321b519313f477..2966971ee43eee913676e5e4203733c5c52a2678 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -970,6 +970,7 @@ do_bch2_trans_commit_to_journal_replay(struct btree_trans *trans,
 
 	struct bkey_i *accounting;
 retry:
+	memset(&trans->fs_usage_delta, 0, sizeof(trans->fs_usage_delta));
 	percpu_down_read(&c->mark_lock);
 	for (accounting = btree_trans_subbuf_base(trans, &trans->accounting);
 	     accounting != btree_trans_subbuf_top(trans, &trans->accounting);
@@ -983,6 +984,9 @@ do_bch2_trans_commit_to_journal_replay(struct btree_trans *trans,
 	}
 	percpu_up_read(&c->mark_lock);
 
+	/* Only fatal errors are possible later, so no need to revert this */
+	bch2_trans_account_disk_usage_change(trans);
+
 	trans_for_each_update(trans, i) {
 		ret = bch2_journal_key_insert(c, i->btree_id, i->level, i->k);
 		if (ret)

-- 
2.50.1


