Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C41D2595
	for <linux-bcachefs@vger.kernel.org>; Sun, 11 Aug 2024 21:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723412541; cv=none; b=jvH8nYx+uwuKHKM95XtpFKNopNM1QT2DUGYjMkLb41XqcG2HBvUegesYoMGaePjEr2RrV0qXzLcAHu4jMsvbpj98E37OLsv/UC0CQwG27ohBXv5B5jXDWrZTFvQ/NFho6puYqGLWowKPOEc61S2S0Q6h7bABy06JyjI1eZSQwZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723412541; c=relaxed/simple;
	bh=j3gEm/3/zegZ5GgA0S1nFcqFsdLvBONaJ2Aei1L/yYg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LflNCjGrnDOMVLTP4rv8FZe3o0OWmYeCrC0C26extO82kiNSWnV/+3GHrYtTXFLy8g+8Am9Qo345Q3mcwsASNoe8fQCOHrHc5WBBX5M/wbveFVZux7kFAa4Bzpww6h3jXDUWiOrTnGBvgkXGkjo6cOTK8jPa2Y1tHb3eIjOPzBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev; spf=pass smtp.mailfrom=badat.dev; dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b=mLr7PdAf; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=badat.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=badat.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=badat.dev header.i=@badat.dev header.b="mLr7PdAf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=badat.dev; s=key1;
	t=1723412531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=j3gEm/3/zegZ5GgA0S1nFcqFsdLvBONaJ2Aei1L/yYg=;
	b=mLr7PdAfPlejTf2LKf9CTDLt8WX10P50J62tUwU9MQQKzT7+b3eYsQXnlk+Na8yu9GdZdS
	YyBMGmovkK2gaCQZcECZHAUxNWd3J2Ne99vl8TKp+hu/wTuBHHsRIgde3SjbJufJz/Duov
	IF0zhaRIl3TqtXSBBUCpfCai29B6q79rKAT4QGzrLnVZwENhJWxJzLuoBG85GJJc50BOJJ
	Qx24pqION2gaENi0vm6vq7MsufVykuDDsxJh7ECt0lexmY/3qXwqthrgGtwjE2FtNiVr2z
	3G0VDixhkq75kGiDkSg3a4JyfWJzglj+xGpZCyC9GSRSHS2Hsa7xbU34G3mOFw==
From: Mae Kasza <git@badat.dev>
To: linux-bcachefs@vger.kernel.org
Subject: 
Date: Sun, 11 Aug 2024 23:40:37 +0200
Message-ID: <20240811214152.86593-2-git@badat.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This is my first time using git send-email,
hopefully everything's fine :)
