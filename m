Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C56A3BBFAA;
	Wed, 19 Aug 2026 03:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787110369; cv=none; b=cgk7fPBCsDkU62OkuFmfjcyLV+3lQvrAbPW92ISL+3PGokJYEIQb0A+A3mdXS1sBxlUPPE4RqgHhLFZrIO7o0GmJGmCTeWsxi73atQiqxDUHIDhtPMll9EBHzEUE/3D5W6ESPTvmi7bmpLgIix4eiXboxFraspIvHA/XeNwoCxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787110369; c=relaxed/simple;
	bh=GCR37VPlLcv/Zr4Z7UkCEjM7E/okWChQWfglGm7DJmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOCeVMXUAedRowsTTLScprFDiei1LhfnybInAu7qHZ6vcElJGtu0UmRZQ/N23BDHZF3Pdve0FbDxEYBeZzyiO8G9a2YdVuF7Rc7TCONub8Al3QLkcyEZdYUgldTk+APZ88k76UX+64CmuhCCv16akxoJqUkaw55q9L4bfr1u1iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V+Y4PbaM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V+Y4PbaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0391F00A3E;
	Wed, 19 Aug 2026 03:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787110368;
	bh=OIUcYoXz6wD/TojGZQaHntEYwMAZDDcX7rbGNdSn0EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+Y4PbaMHjEJJcTC6H2iFAXOnIpdwiDqVPRZmyvO3THn7tM621fq9KaDZxge5TEA8
	 p3TCFWX5yoq+dBASFgzeljmTD6PTb4ndV+27YBiKnOrvCIzCg3Jg5wwOHwdLLsfwiW
	 SKPAVD1SFIASi7B4p1kD+9tml1vybvrCcE+rn0ZXSm9lZoSgmE4CepMUAaII0lyu+m
	 /vB/hEeHXkBqibOK5GNyD/SPQMbh4kpPtKyFQ37O641Tq1Bt8mLyLLmDQbcZ+hFXu/
	 s09xPfOsM7Di4ndj9br88OwkSLirXaKIO1NOHV+9tpgQZScIRuSjW3VXKf1gA3mRg/
	 gFobMamPmSSHA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: Re: [PATCH 6.12] bcachefs: fix memory leak in journal_entry_clock_validate()
Date: Tue, 18 Aug 2026 23:32:29 -0400
Message-ID: <20260818220420.15@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818120253.2627516-1-dmantipov@yandex.ru>
References: <20260818120253.2627516-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A stable-only bcachefs patch with no mainline equivalent needs Kent's Acked-by
before I can queue it.

-- 
Thanks,
Sasha
