Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE4519BC6;
	Mon, 17 Jun 2024 13:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718629337; cv=none; b=t+4cPm+NdpVGSAVTtMe0UEcKzFKAPQswGAwIbYX91BgbqBlk2hIqRUtXoFm6zbQZFrpfGcLNrZCmtLzyofQNFW91Mgkxtz7p9J78HMaVs0mof5RKDQHL8MU54tVDtI0r0t3aSdwdQo6muOk+n7Q1C0Ut/OVhBmFXiUEROH4g93U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718629337; c=relaxed/simple;
	bh=Ed/BCsHrDz5+WndRGDHv9HtTk1vun74wilp9/pFH9KY=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=QJvqJB4vjEhHCYosvLYfWN85FTkW1FwczbP+qySQRA0AhmjtiDiQE9Bs3RBhr2Jk8uCqFtDiuR609rs8YZQ9Fhu0x/4bVVmyHfyhlmygEscUXWGXvr7sI5IJ5dF9HCWspbHhcWlReoDl7KoFjGmmFZrYGJ4oltJzHW/kKFnedcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=LMj1Cu6y; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="LMj1Cu6y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1718629327; bh=ANRIr3s3kc4DpGfYvUCYv8Lu7oilgq7gw5/sKgrkr7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMj1Cu6ypczeGh7SIq1WPxnQ9drh5TMKHru1mu8Ya9dD/b4HZ5ToSWtSZ2fL76ko/
	 2yuKpFJly77zhDKSeoIl5JAKS5qa3CnVo8n0SRL7BwyVj3hnBnWK2BnMgA/kjVpZRd
	 40lndCPKoNeTgBxaJOz8n1VkS0KnrKjJzISTLpFQ=
Received: from pek-lxu-l1.wrs.com ([111.198.228.103])
	by newxmesmtplogicsvrsza10-0.qq.com (NewEsmtp) with SMTP
	id 84A360B; Mon, 17 Jun 2024 21:02:04 +0800
X-QQ-mid: xmsmtpt1718629324tqm16qhiu
Message-ID: <tencent_98E8BEEC66CC4879526C742CA16C80956C0A@qq.com>
X-QQ-XMAILINFO: M0PjjqbLT90wtS5jLRiqO6J/f+DARIN0qQ6d4bLvoglJpP6s2t8QlyOyOZxUWl
	 ce4lie/579ulsUeXGIOYh1Pb8esf8MgGaY+FzB1PcpJFWnOBnx2Ojv5+G7Qm0HV5xcCeUfjJ+wZD
	 fpyQZwu77KXWC1LDPgISJZuFdUq8vKv/kNntqbp/5TkZ25LJEarGQrhZLtcVd9EWuSfFQcfkwQ8O
	 7LWtGi0m7q15yq0n0HBWhmeCp4IwZrnHfEbe3cmGPTUdJaLVc+bpEKqpfs9nMzQj1/H9xwovRJ++
	 0mlVIg3X5ooDaJAb9sDz5BfphiCaq5mESjVdIMIClID5oQrafDqunmSLcIyqISMfi9Q1ZMAfVAzb
	 N8zn0Jv+yy8uUVogsfa/IdR/CF8v96nCupI2P403IlLgONmItd15duabk3Q3ddAkdSyjJwKtOEVM
	 9DUzasdF7vYOk6L8X9Ha5ChTfcTINye2QuANh3ZP9KtMQ6aGeprCeyapylR/KOls6JbCb/GMtsAF
	 N3CFp5V+kYvMJ0n28ogCVmU2c1QOkUH8vyMOij4JdwGhKrCCUlg7UHsop/UBZQR0rlBfvob/QX4v
	 +nmFQDxHUXe8KpRCD3lo3uNAWegTkDlIJ3XTnCZ2iCClMkezlALbYmmN0ec7jkAV2+aHwPQ2iwO0
	 IBonmQ+GkSlgjqT8O7jBaGe6WNYZkuEI+iBozfbByz0yARH4KUWOT9SDnxwuZifOSzUGYXh8Nm6z
	 tltc7chxR2CA0cPW8yW92LzA5HYg6z30LQ4ncVuKQXRXDH9SIpF+CXEodMQTUqJTatQYaAd8Sskq
	 OusjtQzYSUcb09z4zFe6/ijPB92W+vRXEi2KO1l4/1j6yZJivgs2xh181+7qKOWTZ1LjLvuXBGhF
	 g7VtPM3icze3PbycneR2UWxVGTLfK+7cbOqS7dMP8AVi4yi6htJmDpqfTAuIYa4hp1cER7NNWN8T
	 yjmMjwkWw=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+6d3e28b33490b3085412@syzkaller.appspotmail.com
Cc: bfoster@redhat.com,
	kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] bcachefs: Check and reset ro_ref in bch2_fsck_thread_exit
Date: Mon, 17 Jun 2024 21:02:05 +0800
X-OQ-MSGID: <20240617130204.773068-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <0000000000009a83e9061aeac50d@google.com>
References: <0000000000009a83e9061aeac50d@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following is the normal execution situation:

CPU1                     CPU2                       CPU3
======================   =========================  =====
                         bch2_run_thread_with_file
                         bch2_ioctl_fsck_online
			                            bch2_fsck_online_thread_fn

                         bch2_fsck_thread_exit
cleanup_mnt
deactivate_super
deactivate_locked_super
bch2_kill_sb
generic_shutdown_super
bch2_put_super
__bch2_fs_stop

If the execution of bch2_fsck_online_thread_fn is later than that of
bch2_fsck_thread_exit, it will result in the ro_ref value being greater
than 1, when executing __bch2_fs_stop, the wait_event wait timeout will
occur due to the fact that the ro_ref value can never be 0.

The solution is to check the ro_ref value when exiting the fsck thread,
and if it is greater than 1, set it to 1 to avoid timeouts in __bch2_fs
_stop due to the ro_ref value never being able to be 0.

Fixes: 267b801fda10 ("bcachefs: BCH_IOCTL_FSCK_ONLINE")
Reported-by: syzbot+6d3e28b33490b3085412@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6d3e28b33490b3085412
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/bcachefs/chardev.c | 5 ++++
 1 file changed, 5 insertions(+)

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index 9e54323f0f5f..487a01db2b72 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -135,6 +135,11 @@ struct fsck_thread {
 static void bch2_fsck_thread_exit(struct thread_with_stdio *_thr)
 {
 	struct fsck_thread *thr = container_of(_thr, struct fsck_thread, thr);
+	struct bch_fs *c = thr->c;
+
+	if (refcount_read(&c->ro_ref) > 1)
+		refcount_set(&c->ro_ref, 1);
+
 	kfree(thr);
 }
 
-- 
2.43.0

