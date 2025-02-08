Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30461238748
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012494; cv=none; b=KNi+9g68F7PdL0osSBWxoBtlznOZTe+45GE482tJXXCzaNC1yMNY9DPZAueUh1IZf+qKzWVUvZ0o2nosXIxAjN0e8Z/N/qRuYBdcOKfquPH1zXMSumdVJmaqhkZkbNyS70mHJaxQynL+bc0NfwtOniVZYHgoIOqPcex1VpkDhsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012494; c=relaxed/simple;
	bh=Of7w/UzWy3qSBpqvj3VvtK3T0Ayb3r1css1UujBwyJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEFqfreHLgL+dVxLOvU+nopgXg4+I51hQmmnf+laGKi1w48HU+qX7KKOPR+07+gvAlvrzjA4KOiCEBCg35Inu9/Ra0Jpc83Djfss3+gkXGaJnAMI6El3wY1PD/08QFTARv7tUQrw5IgYFgaiFzhFcU7KApVkfmjBohvBkDK+3N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OqCO4Ivm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OqCO4Ivm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWfgl39ESWnbHBKlabluIWmGPvKPwzX59+8JuU7XmT8=;
	b=OqCO4IvmUrs1qoHP89bWmVdK0CAU+OHMj13E1wCkaqUwFTgK45/oqERLLX59RJwPc2RcjA
	5RazTHt+loee7duazRgPDy6Hu5eUpguKaHKD68MsRsBtphjk+5oh9zSSEnYiehQfgIWWoB
	43lcfFAKy2oGYnhrEl/xHDOA3w+DlnU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-191-bfq2-Q9aPYKWhsCkteLRoA-1; Sat,
 08 Feb 2025 06:01:27 -0500
X-MC-Unique: bfq2-Q9aPYKWhsCkteLRoA-1
X-Mimecast-MFC-AGG-ID: bfq2-Q9aPYKWhsCkteLRoA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0AE7180056F;
	Sat,  8 Feb 2025 11:01:26 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 48DDB3001D11;
	Sat,  8 Feb 2025 11:01:24 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 02/21] bcachefs: EYTZINGER_DEBUG fix
Date: Sat,  8 Feb 2025 12:00:59 +0100
Message-ID: <20250208110119.546961-3-agruenba@redhat.com>
In-Reply-To: <20250208110119.546961-1-agruenba@redhat.com>
References: <20250208110119.546961-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

When EYTZINGER_DEBUG is defined, <linux/bug.h> needs to be included.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
index 0541192d7bc0..5f2f96b1295e 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -6,6 +6,7 @@
 #include <linux/log2.h>
 
 #ifdef EYTZINGER_DEBUG
+#include <linux/bug.h>
 #define EYTZINGER_BUG_ON(cond)		BUG_ON(cond)
 #else
 #define EYTZINGER_BUG_ON(cond)
-- 
2.48.1

