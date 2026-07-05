Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798364207A;
	Sun,  5 Jul 2026 14:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783262033; cv=none; b=k698GF7ah/83avyfOObNw8lbnvXPXwfgPmU/4ITJNGSP27vRwMHyHISpeya7x5hkKZtRIApVTKvmumpwh/V/ieER+FjGAsDHFZ/qfBu8lxSKCDbDth3fDZ50cdG7k9ACNmAx5Lw3abeXnAuiJo8yFIovFHBHVTYtwCzr0GDHmAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783262033; c=relaxed/simple;
	bh=OiDtkJsieqRUiUEt2xafKLxCnchfXTrqpIfWiz0Dtv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxKaHu+uGFt6cTnhK8pZ8d37uNyXqyF2LQTTa9CVKuQncg+ZXXyxW8fYXHvbts53VVj4m5Dt927VHkJJ8zK7sBjsoYjyrtk467Hb0pGm4/IGPfaldhIxNbBQdIhZsa8Pn2QWBvCPWRIsTtikLLs051hOMir4kBD57OnrRZ14LQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5rtwtgR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5rtwtgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366991F000E9;
	Sun,  5 Jul 2026 14:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783262032;
	bh=1iWBF/ZAjE5MrNiAFWR6Vk6YDuxQRd+A/EYrbtPoUfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5rtwtgRwcARVVcvo8V6v3rm+bcI4TkZVpFSGdDyK44XAc472y0diWmh+IZjAZoiF
	 +c72lZxrOl75kIX93K2PrjiHLaHMJifCcAes9Ms0U7hJdO0cZIk/6dSgsaZWOzAUtj
	 Lw8Fd0qkrCkEGptY+Veg3/2R9/TfkE678o5X6brZZOK5pau7zajP4omBA1fLHWnlqD
	 ZBMcFba72IITi1yWN2AXZsGSPKUF1sdD4cy4gw7SyTMElT+Uw9c/i7wFtxHyEbMO7K
	 g58xnajxKWBUMUnDPrRgh5gaYFc73mr2ADytBrVcNWVUifOuUVsw3fUsn8WfrmwCHX
	 IcAHPfyoMrzZg==
From: Sasha Levin <sashal@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH 6.12] bcachefs: avoid truncating fiemap extent length
Date: Sun,  5 Jul 2026 10:33:48 -0400
Message-ID: <2026070510-stable-reply-bcachefs-fiemap@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <akkdYigsmB8tJf6T@shelob>
References: <20260703114813.113406-1-mdmitrichenko@astralinux.ru> <2026070315-stable-reply-0028@kernel.org> <akkdYigsmB8tJf6T@shelob>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, Jul 04, 2026 at 09:49:11AM -0500, Kent Overstreet wrote:
>On Fri, Jul 03, 2026 at 10:05:22PM -0400, Sasha Levin wrote:
>> Thanks for the patch, happy to take it if we can get an ack from the bcachefs
>> maintainers.
>
>Ack

Queued for 6.12, thanks!

-- 
Thanks,
Sasha
