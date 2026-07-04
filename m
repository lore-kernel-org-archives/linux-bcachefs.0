Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9542B372EFA;
	Sat,  4 Jul 2026 02:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783130764; cv=none; b=i86C6LnDK37h31k0IaOzxK1dlIOtHcxfmSAgbaxGvfKjkajcct8K6/dhSg9pNBlIobIKNhVthufPq0m5VszEldatOeK3EI1E3dp31u9cNoKvNuBao73EX1vePjUTUMGrqkZagZGNyhjNwWWscv0lu6fRdwyQJrR3kooGAk6XNss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783130764; c=relaxed/simple;
	bh=TObkTKyeHlxvkEWg54CrQuc0EBClQ3LxMCykHlqEKCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lydcabVc5n1OjqMTG9Ke2vH+LNeAwTGqXKCr+ZL3X7/kL7qNrUMuf3DfgMxDt7DlihFFk9AutquoOStkO0y9xqXP2PkzLyVtGPXiAopuQeQP1eAh56sWWqWDTCzeZZ/v6P37q8iG5jRpyyMcMaU38bbHSc1eARKr3npZR/PQp6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCymFpdy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCymFpdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5841F000E9;
	Sat,  4 Jul 2026 02:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783130763;
	bh=QwJOkaKz4b3D76JlG67IrJh8qpMMgQb5aqeXaQhKbFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCymFpdygGrn2bTTE6GMzgGa5yMK3QmE7HSTFQwAdq305Z3X30Ow+018AtNfEvlUy
	 hKsDIzQ22b64Ggop3z40GK7ChBlfgqk4mWYTTkR4sWM3B8PCyn5fF6bWV+8LLwahGy
	 VUa0r0NauVGg6FGvujaYlYswv2EHZeG2JCcKCxv2rTj0xzOPIx3hevYR240zaq8Edl
	 dpEIIXq3YQmjH1c54xwQ1JHlCcDL+ZpZXVQ3PGeOerwDeqJ3zBWqz7+utqqdvFWfNA
	 2WICpdN/J+AcXqkXzWEjyig4IMfNjgQJhzSFoodsb2IqP1CzrXKFBImnctcEDQUcjf
	 JwuO9FABCYlng==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH 6.12] bcachefs: avoid truncating fiemap extent length
Date: Fri,  3 Jul 2026 22:05:22 -0400
Message-ID: <2026070315-stable-reply-0028@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260703114813.113406-1-mdmitrichenko@astralinux.ru>
References: <20260703114813.113406-1-mdmitrichenko@astralinux.ru>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Jul 03, 2026 at 02:48:13PM +0300, Mikhail Dmitrichenko wrote:
> No upstream commit exists for this patch.
>
> bkey sizes are stored in sectors as u32, while fiemap reports byte
> lengths as u64. Shifting k.k->size before widening performs the
> conversion in 32 bits, so an extent of 4 GiB or larger can wrap before
> it is passed to fiemap_fill_next_extent().

Thanks for the patch, happy to take it if we can get an ack from the bcachefs
maintainers.

-- 
Thanks,
Sasha
