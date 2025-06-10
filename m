Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9377328AAFF;
	Tue, 10 Jun 2025 09:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749547457; cv=none; b=Nu45fNTgMlJKz8SWGM5YQDEorxmSDJe85Gp2RIBEmEE7bBS1jVijT+qY5OmyVXArccK1Kw/+ebV+IqlP78IL/tIFJz1MPu64NJUH3IR0aLnTuj+mNmG+pV7Y2267e70G6SXQsEa+Dg0eTfZVgo3Hp8vfIR6I/AvuJY1vwHNZLBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749547457; c=relaxed/simple;
	bh=DXnxrZCKNCbvmNqckFGO7yqFhyxX1F28F7u/tRCZUCE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uYtLoizyRl29dfPaBdxDJAKjJ+qPRhiVAckaUWzACHcxhPzVvLfKz6zZrAReWxt2Sr9fhW6xSSYiWFZx9QCRMDguybbwSX06qBIwFpD45tUkuMk7NDkzRuFd26obSgBzNQAiQnCZ7ncqMWl7g5M4Ri3Q5djEoWnTs6D1Ej5G9nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEbp9dZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEbp9dZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E2CC4CEED;
	Tue, 10 Jun 2025 09:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749547457;
	bh=DXnxrZCKNCbvmNqckFGO7yqFhyxX1F28F7u/tRCZUCE=;
	h=From:To:Cc:Subject:Date:From;
	b=AEbp9dZb8IWFBmoWA6giJjGXvzs6CbRsjZgQLpkdE8IPFTQVz0FrKmTcxgy8zJRWU
	 RxVoLyzDomXui+aiFcLNAk8mF8CERJInhxrjUDzD+n48BOHc/R3K1C9nEzW4X4lUxU
	 h6oHu/UGRrHM+IMhc76VEWsCWny3x78WIeu68Lmt5myp9BW7RV6TPhpYl/QUnFk2Pp
	 XfvsRm3ZjFxC4766MQMfcA72mcl9Bqq0nk+VGuzIsdSSFzC0tZEndwf9jDagI5htMd
	 Pzw4oiolaYx97vLFS5yRuS03pygMuTFWPjKiWOjde6SPW5xGwjYL050jT0ZqtnvWYE
	 Kxl+zacuaxp/Q==
From: Arnd Bergmann <arnd@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Thomas Bertschinger <tahbertschinger@gmail.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH] bcachefs: ioctl: avoid stack overflow warning
Date: Tue, 10 Jun 2025 11:24:04 +0200
Message-Id: <20250610092413.2640349-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Multiple ioctl handlers individually use a lot of stack space, and clang chooses
to inline them into the bch2_fs_ioctl() function, blowing through the warning
limit:

fs/bcachefs/chardev.c:655:6: error: stack frame size (1032) exceeds limit (1024) in 'bch2_fs_ioctl' [-Werror,-Wframe-larger-than]
  655 | long bch2_fs_ioctl(struct bch_fs *c, unsigned cmd, void __user *arg)

By marking the largest two of them as noinline_for_stack, no indidual code path
ends up using this much, which avoids the warning and reduces the possible
total stack usage in the ioctl handler.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/bcachefs/chardev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index 2d38466eddfd..fde3c2380e28 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -399,7 +399,7 @@ static long bch2_ioctl_data(struct bch_fs *c,
 	return ret;
 }
 
-static long bch2_ioctl_fs_usage(struct bch_fs *c,
+static noinline_for_stack long bch2_ioctl_fs_usage(struct bch_fs *c,
 				struct bch_ioctl_fs_usage __user *user_arg)
 {
 	struct bch_ioctl_fs_usage arg = {};
@@ -469,7 +469,7 @@ static long bch2_ioctl_query_accounting(struct bch_fs *c,
 }
 
 /* obsolete, didn't allow for new data types: */
-static long bch2_ioctl_dev_usage(struct bch_fs *c,
+static noinline_for_stack long bch2_ioctl_dev_usage(struct bch_fs *c,
 				 struct bch_ioctl_dev_usage __user *user_arg)
 {
 	struct bch_ioctl_dev_usage arg;
-- 
2.39.5

