Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D4CBA53
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jun 2024 12:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718022373; cv=none; b=SoCBNmEa4n5GpNIau3mCzUDlU3cyzqEuoHjiC9fW7szlMIN18/LHTsxW3DJEW43GPmALDRLyRza+9gOvhtiqx4BciQC9InGoa6GPGtNoiHWHjwrYY62gSeSlTB5w4V48odwCL9OPDQs8bmyu34K2wYxTn55SmJlZXhsohggKYCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718022373; c=relaxed/simple;
	bh=Pkaj9+8yx6V00xVZybwSu1d2BVR+BNBYFEP/8sqWQxM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lgZdwD0hbh0WUeML9lgPrG28gUbx7FWzPF0kWVlk6ODiGuSn1HGyiIDSLweFFw0I4aM0+IJefRbeFfiie5gFl0zcwxAuQnaSvM6mEfV2svR4KrcqpKLZJHLYw98Qtacnt8P7RIYh1XVpp/JOqpPfJ3vSeD+wuP4Wqa9su+Cky0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aXdg1Xbv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aXdg1Xbv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718022370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oK573xGAbsL+sKW3GUltI7GzsgBc6NQbwtIwG3O5Rcc=;
	b=aXdg1XbvsJpD8Iev/CyQvwt/Hh4cRiUL/zdHnnvupLgWTh5Jj06IUwGyCHiDBAC6mz1byh
	ty0Gvy1VByt/70N2fKUt1662wlUkxO8X+Uh9cE9mbyS8LdBXr5E/FjW4pGQlnXlN+OYi4Y
	8DMGP/9nBU+HO+nKITXkpj5iakQ5LFk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-94-h-Yz1TdhN2CuzXZs2yaIRg-1; Mon,
 10 Jun 2024 08:26:09 -0400
X-MC-Unique: h-Yz1TdhN2CuzXZs2yaIRg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 631F819560AB
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jun 2024 12:26:08 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D763830000C3
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jun 2024 12:26:07 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] MAINTAINERS: remove Brian Foster as a reviewer for bcachefs
Date: Mon, 10 Jun 2024 08:26:39 -0400
Message-ID: <20240610122639.44021-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8754ac2c259d..128bf05e981c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3672,7 +3672,6 @@ F:	drivers/md/bcache/
 
 BCACHEFS
 M:	Kent Overstreet <kent.overstreet@linux.dev>
-R:	Brian Foster <bfoster@redhat.com>
 L:	linux-bcachefs@vger.kernel.org
 S:	Supported
 C:	irc://irc.oftc.net/bcache
-- 
2.45.0

