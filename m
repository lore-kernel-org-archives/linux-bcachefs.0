Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C5621C183
	for <linux-bcachefs@vger.kernel.org>; Thu,  1 May 2025 20:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746130325; cv=none; b=FensukY/Clv7ZD54yxG9soBtr047Bgo8cN36zsj0a/psCjS2iQby6A8+DM7hdiBlF+9QIw141iCzfRDafzsFfWVVvjR5tYBNIJJInaeK0gXPYNEGwKu7IICF8y40PY2t5tZ4quokYj0rIBVeIXu0caL31LtaNPII6cpg1v1CpKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746130325; c=relaxed/simple;
	bh=GfNxm9SoS0WiJCAolHiTCfNgdi97giXoY29wlpEiBhg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=IL1pljouh539J+eo/bFRZ80xNsQNkgbEd5IRJem9Yvw6OvwSEu/pLoH6nraZrZKHjC7FY4gz6qtScGk2zCOr3Ao98Rk3m7Kv6bS4KpZdbVGoAQkjQ/8f74TfoR2LjXZz228vi7NYgUVeT8N3j1YsOjo4lQj04JqUbBdbj75s7vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g3bMEWut; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g3bMEWut"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746130320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GfNxm9SoS0WiJCAolHiTCfNgdi97giXoY29wlpEiBhg=;
	b=g3bMEWutCQ5spMfx8WorcXszSGtf0Kts1kopfp6FjiHH4w9lAiCGM3gD9XTExpTQe0SDMt
	cdUsfCjAYUEULGSjO/5Gx0URtjDsSVt5DXqvzWxBDmof4gRhg0MUPvN8cnmRidT8EgvSDW
	8EPzjXpjEeIR8YCEGWp+5Mk0KuDmyO0=
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.2\))
Subject: Re: [PATCH 1/2] bcachefs: Remove incorrect __counted_by annotation
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <9BACA2F2-D306-46BA-ACBE-E06460E11FA0@linux.dev>
Date: Thu, 1 May 2025 22:11:48 +0200
Cc: kent.overstreet@linux.dev,
 Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 linux-bcachefs@vger.kernel.org,
 linux-hardening@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <565BE763-1464-4D36-8EBC-E106B4AE378C@linux.dev>
References: <20250501200132.216859-1-mmpgouride@gmail.com>
 <9BACA2F2-D306-46BA-ACBE-E06460E11FA0@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On 1. May 2025, at 22:08, Thorsten Blum wrote:
> Instead of removing it, would __counted_by(x_name_len + x_val_len) work?

Ah sorry, never mind, that obviously doesn't work.

