Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC7A20AF9C
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Apr 2025 03:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743565200; cv=none; b=Hye2XiGpSDt9z71+qU18chuVQIC0dhQPfSZvuXvbFw/gacAjv0eQCy419VYsX0MndoiB3BeB+rSmourJqIkGr86zJBY2T6jOpLlZPBzLh5FRn1E6IPDhQfiiOIKa/fm3zgCh6kCpO8TAmsnVvJA0ujbuD4K327+HFBy5D5c/fNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743565200; c=relaxed/simple;
	bh=tzpy2tzQVkRZrGHYSoxOjum67jCa8TWxGUVwUchBuWw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Vu6lHUFl+zAua/zpRTr/8bzYhiuqf2iZPDIM+WsukjfbzYivL6w2hNO5ZMs6i2On4KNCWaov1sWHRlXi7rNTHf5WRGr1F0kmIbEpAvZMcMZjOtPKaot7QIiyXwofIPJleiy9dwtfkQaKwMzDTf9GS5qKFH7MfnIVv74SJU/ff0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g92yvlbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g92yvlbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2E6C4CEDD;
	Wed,  2 Apr 2025 03:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743565199;
	bh=tzpy2tzQVkRZrGHYSoxOjum67jCa8TWxGUVwUchBuWw=;
	h=From:To:Subject:Date:From;
	b=g92yvlbtWEX0UnMmHOPOsRJP2bCtkqgDsMj/jW/iQVC0aWR4M4dybbvZRzk1Halnz
	 gf+LkwxrGZHZ9PMwjNPXeebFMzbRLAU+wNO3caA8vfAO0fW1O4IsATo9qN1rEdkJpz
	 nVB/yv2tTxpRQDTVlvfGLsO1SzICTTQfWDRK5n+knm9ztlxqk2lOIxMMNDIztxSu6O
	 VJnetWE7PEt/1FAQC57Ue53kOJA240T+w2KlpoMj9pykhZ26ldtLb9z3YDvgjE5/Xr
	 7kU8W4gdveNSkLQ6qDgIjQv+P0qhwcuiAjGpj2MFxEb1HsqzmVpTUWtpuw16wGE521
	 /EP45W+J9IlXA==
From: Eric Biggers <ebiggers@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org
Subject: [ktest PATCH] root_image: explicitly chmod the image to 644
Date: Tue,  1 Apr 2025 20:39:31 -0700
Message-ID: <20250402033931.282645-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Otherwise it is inaccessible to non-root users on systems that use a
umask of 0077.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 root_image | 1 +
 1 file changed, 1 insertion(+)

diff --git a/root_image b/root_image
index f2f36a4..964c791 100755
--- a/root_image
+++ b/root_image
@@ -331,10 +331,11 @@ cmd_create()
 
     MNT=$(mktemp --tmpdir -d $(basename "$0")-XXXXXXXXXX)
     #trap 'umount_image; rm "$ktest_image"' EXIT
 
     fallocate -l "$IMAGE_SIZE" "$ktest_image"
+    chmod 644 "$ktest_image"
     mkfs.ext4 -F "$ktest_image"
     mount "$ktest_image" "$MNT"
 
     DEBOOTSTRAP_DIR=$ktest_dir/debootstrap $debootstrap	\
 	--no-check-gpg					\

base-commit: 53229b36f8c4df0690af64dedfce3e247334505e
-- 
2.49.0

