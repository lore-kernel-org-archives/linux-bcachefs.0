Received: from andre.telenet-ops.be (andre.telenet-ops.be [195.130.132.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BAA1F4289
	for <linux-bcachefs@vger.kernel.org>; Tue,  3 Dec 2024 16:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.132.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733244016; cv=none; b=VgW5Fekn0vosuBVZciLgld5sBR1AfrXmBsjAXXOtQ2nbaIHRahHwg9FWB3HKh9deGnl4VF1n5LJDyHpkMf8AJ2fpr616agun+FxQ9w899K0fgWnxVfpH/wxE8ug9+V+ROcanBDBWkNivT3fA0nNYFEE9fke1QOc4VqxcKroQTLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733244016; c=relaxed/simple;
	bh=iers8YwQihT5WN+yXYzlgjChPlB3E49WUvV+hZjKU+8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GaETOwU13TPN2RRuPZLRs1QHv+aovFuOZv4SRRfLabqMxuRWo3O8sky5+vKrPsIRziWCZNjY5x2UcqDGDfsUR+SgqujpRQRk8cUEFmMTL1DnGjCOLAX1xTscodKHm/IruUiU/xZ4VUoxQNFlB+4HkIf9HSgaFowxust8wDUyYRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.132.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:829d:a1e7:5b32:5d8e])
	by andre.telenet-ops.be with cmsmtp
	id kGgB2D00M3sLyzB01GgB42; Tue, 03 Dec 2024 17:40:12 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1tIVwZ-000DZC-M8;
	Tue, 03 Dec 2024 17:40:11 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1tIVwZ-00Aj1O-JM;
	Tue, 03 Dec 2024 17:40:11 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-bcachefs@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH resend] bcachefs: BCACHEFS_PATH_TRACEPOINTS should depend on TRACING
Date: Tue,  3 Dec 2024 17:40:10 +0100
Message-Id: <2d26d15c39b72c815f14593b8cc916d47e82402d.1733243875.git.geert@linux-m68k.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When tracing is disabled, there is no point in asking the user about
enabling extra btree_path tracepoints in bcachefs.

Fixes: 32ed4a620c5405be ("bcachefs: Btree path tracepoints")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/bcachefs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/Kconfig b/fs/bcachefs/Kconfig
index ab6c95b895b33591..464b927e4fffd1f2 100644
--- a/fs/bcachefs/Kconfig
+++ b/fs/bcachefs/Kconfig
@@ -90,7 +90,7 @@ config BCACHEFS_SIX_OPTIMISTIC_SPIN
 
 config BCACHEFS_PATH_TRACEPOINTS
 	bool "Extra btree_path tracepoints"
-	depends on BCACHEFS_FS
+	depends on BCACHEFS_FS && TRACING
 	help
 	Enable extra tracepoints for debugging btree_path operations; we don't
 	normally want these enabled because they happen at very high rates.
-- 
2.34.1

