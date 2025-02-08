Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE36239582
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 11:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739012500; cv=none; b=nTA78KtCC7XRZqj+BR6pI61QZ3vzgGrfafMjFAOBnibnWIHHeBVlhTo+rpwfMVCUaVtkoiLdg4MrHfuHuCLqsFrV5JaCbGFrNtgDZctDnsVYEdP3i75GgFiV82AFWVYJSKGrCpumCkMDhHitAle7mEHDxXIt5qtgpaPjAOodJd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739012500; c=relaxed/simple;
	bh=TwVOFXCuYFZAuPajYgjNaQtXp0esNlRWOavOR0Qt2JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4HJVXj+Zft4H8Gp80OMniqTapIWtLKHVMTGR09UDti+Tnt+nGqr9SXotgI04EwxYOJT9W6mKsxR9MRQwty5xNIFnoLPhkqtsT2vgeKEK0v7qYm1gbj01XPxTNE2EG93/iCbWT68eU5SPdrT8YCY0NLrzlDsn0jzhbpiIy8vZLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NbZwzCCQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NbZwzCCQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739012497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UgCANrwipp/E+ZSYqxhH8p8SLIf7d/pweXHzdmaO0SM=;
	b=NbZwzCCQPqStJ+kIs+qezzc7GwbDfu5eQC5djOao4gmjuqLdR10aCu2sxoKi3oaNTXlp4o
	PWn/1U16EHFjCU9QBD7Jen5ePzOiSPXzCyhCd+9E+7li+IgRIB6FBt5Cu9EE5m+CJUM0uv
	VmsjJlS20V3trnSdxGcfYLtFY8SvK5o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-591-bYrOINbcPj2EiSkeI8bUtA-1; Sat,
 08 Feb 2025 06:01:36 -0500
X-MC-Unique: bYrOINbcPj2EiSkeI8bUtA-1
X-Mimecast-MFC-AGG-ID: bYrOINbcPj2EiSkeI8bUtA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 306351800360;
	Sat,  8 Feb 2025 11:01:35 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AE49030001AB;
	Sat,  8 Feb 2025 11:01:33 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 06/21] bcachefs: eytzinger[01]_test improvement
Date: Sat,  8 Feb 2025 12:01:03 +0100
Message-ID: <20250208110119.546961-7-agruenba@redhat.com>
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

In eytzinger[01]_test(), make sure that eytzinger[01]_for_each()
iterates over all array elements.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bcachefs/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 84f139154701..953ed5ad38a4 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -728,6 +728,7 @@ void eytzinger1_test(void)
 
 			inorder++;
 		}
+		BUG_ON(inorder - 1 != size);
 	}
 }
 
@@ -761,6 +762,7 @@ void eytzinger0_test(void)
 
 			inorder++;
 		}
+		BUG_ON(inorder != size);
 	}
 }
 
-- 
2.48.1

