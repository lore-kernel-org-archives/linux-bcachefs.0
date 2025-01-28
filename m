Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260181DE3A8
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Jan 2025 16:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738082360; cv=none; b=U2vj9WWB3c2xQ8IpdCQWhfCslhF/jzGyKnGRcSG/437hrDtQ85TW9alAE3gVopMjySTyryJL8krIOmYMDZzkOamRipURzCbazQD4Wceh3lgmipFyfhOrK1CtlO8LxIzhpzQUdDb5FJ7ZogDXAUkpp5MUEw/QBDljjHAUtUncbiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738082360; c=relaxed/simple;
	bh=80V5ZD3kqKIEt9ykSkK9ujmtNKhjg0TdGjBMSGp3CxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OapNEL3yfkDr08d45YqERPplTJN1iekWJzOlecKIcYlJF98/xiqf9y3qwarDKosPwOYXfTXVM+PhQDWKixfdPL4qSyogQYKTzS50p5O77OVehqQn5OBDgUpaQqNCOzvI1F7yYEnz/DNYjVkcNq2df+disIpoN0FzUTTQBb7VDYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LVrcBto2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LVrcBto2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738082358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RFsVTpVx9tfu2gtY/FcLf9k1nGGY3NJBOkFAp0nnMYI=;
	b=LVrcBto2I7mSy+uSuAD+x1283b33BoN1xmCv/N9dDV+Ic5xLOTddifBw4oiEcR9T8/zpx1
	s9JVyaPE8PhdevYCFpuIKok38PMiK32P5/9AitK4e40sH2L+yLQIju1FltipymWKmzf4OZ
	l9Spa2/g4q2CiwnMJiFlvfepTHxJgHc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-i_O4QtVUMoCT3VCvHwK1gA-1; Tue,
 28 Jan 2025 11:39:13 -0500
X-MC-Unique: i_O4QtVUMoCT3VCvHwK1gA-1
X-Mimecast-MFC-AGG-ID: i_O4QtVUMoCT3VCvHwK1gA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB4CB195608B;
	Tue, 28 Jan 2025 16:39:12 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.225.106])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EB4A4180035E;
	Tue, 28 Jan 2025 16:39:10 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Shuah Khan <shuah@kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 04/21] bcachefs: EYTZINGER_DEBUG fix
Date: Tue, 28 Jan 2025 17:38:41 +0100
Message-ID: <20250128163859.1883260-5-agruenba@redhat.com>
In-Reply-To: <20250128163859.1883260-1-agruenba@redhat.com>
References: <20250128163859.1883260-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

When EYTZINGER_DEBUG is defined, <linux/bug.h> needs to be included.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/eytzinger.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
index 16303908ccff..6fa6d51a5420 100644
--- a/fs/bcachefs/eytzinger.h
+++ b/fs/bcachefs/eytzinger.h
@@ -8,6 +8,7 @@
 #define EYTZINGER_DEBUG
 
 #ifdef EYTZINGER_DEBUG
+#include <linux/bug.h>
 #define EYTZINGER_BUG_ON(cond)		BUG_ON(cond)
 #else
 #define EYTZINGER_BUG_ON(cond)
-- 
2.48.1

