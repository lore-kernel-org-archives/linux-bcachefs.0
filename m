Received: from mail3.ecloud.global (mail3.ecloud.global [135.181.139.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A488140E38
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 11:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=135.181.139.185
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729595884; cv=pass; b=V97pt4kqt/NhESb7f/K5kMOmo7EKrWVExnZ9MCFeyOx3tmH7H+IwcDJXpMtTSNcgtiJEK7y5V3FHUBu7HCfiRl2duwGGQMvEF5KqMjfQuIJ7vmBXLG3JbO8fiS1aeX+21YA8fJrB3FzrwACp8QzRnHmSyhKsCnLxmyF3VTlhiss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729595884; c=relaxed/simple;
	bh=H/9pfhoE+0WXAZ0Riwvygz+jVRIgxzDZjA0khbwWuhs=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=C8SONUxi/XKDTau0zJ58c3MoZfUwvTDW1RQqqIjuvx2KEj+4pJF/1682ngWyiCmdUhAxLnb+v4ssMBk9nei3pI9Yzff3nRj8ZlfAGVCFo6RQ2qiA/R8sZwubI3ZMuNec1PbQRzrZ83XwP/w1rGZF7CObixT//Ni0drcp5QOaZL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io; spf=pass smtp.mailfrom=murena.io; dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b=MbfEsL5d; arc=pass smtp.client-ip=135.181.139.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=murena.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=murena.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=murena.io header.i=@murena.io header.b="MbfEsL5d"
Received: from authenticated-user (mail3.ecloud.global [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail3.ecloud.global (Postfix) with ESMTPSA id D5B3E883F9E;
	Tue, 22 Oct 2024 11:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io; s=mail3;
	t=1729595000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H/9pfhoE+0WXAZ0Riwvygz+jVRIgxzDZjA0khbwWuhs=;
	b=MbfEsL5dWT8MOqtVI+zAJjHNnT7r5MCe38DDG9PK7k1U7pDZCVzqR3UexLVmEzI25/xlvU
	vc13ZqFzkdiXp8jZeNJYOcfA0bgfNjLoJg9Iz0eeo+R8cqjuF106QiszymZNo1FRbklD0e
	66XsMMEPF5zBKgKvCnHowKO4Ph2hBco=
ARC-Seal: i=1; s=mail3; d=murena.io; t=1729595000; a=rsa-sha256; cv=none;
	b=AZAUGhsN+Iy3a9AdfX3ynIcaJ7MzOCHvPNPZoTYkny1GBLvAo+PiaIt6px5tqH/YatoGpx
	Z7MkarPNud2uRA77TWOFLG/7is/APIXHr3f9SvPsUZejMclN+PB/K4FpUWCpzLJHW5CXOp
	wBi50pI5EcpKRXarWr69GHtF9JOhK6Y=
ARC-Authentication-Results: i=1;
	mail3.ecloud.global;
	auth=pass smtp.mailfrom=integral@murena.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=murena.io;
	s=mail3; t=1729595000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H/9pfhoE+0WXAZ0Riwvygz+jVRIgxzDZjA0khbwWuhs=;
	b=5KkTUeLycWCmPqavlPA3xpHGWm5hty2dEm96YU+lUDdS7hpw4lnVy/gBupT4N8iFSYnyRP
	RRJKNdmZX3wbddy/ct8I+DN/K/+h7/6hizmMULZqp01SpKs5ZVay9E7LiQc/IxTT06dg4Y
	Wl6ptZFFo5Blmh1eDPgxeuTX8+tkifg=
Message-ID: <772ebe74-f502-46c5-8f02-c2dfeea24c0a@murena.io>
Date: Tue, 22 Oct 2024 19:03:13 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: integral@murena.io
Cc: kent.overstreet@gmail.com, kent.overstreet@linux.dev,
 lihongbo22@huawei.com, linux-bcachefs@vger.kernel.org, mmpgouride@gmail.com
References: <20241003114012.297236-2-integral@murena.io>
Subject: Re: [PATCH v2] bcachefs: add support for true/false & yes/no in
 bool-type options
Content-Language: en-US
From: Integral <integral@murena.io>
In-Reply-To: <20241003114012.297236-2-integral@murena.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Any progress on this?

