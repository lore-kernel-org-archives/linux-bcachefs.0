Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC2E13AF2;
	Thu, 20 Feb 2025 22:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089289; cv=none; b=j2ytycVsc522BAUivuHXUSxlLvOFNs73x4mFzwe4h4DVfxbVKOKEMeKueNcF9YP7NYgsaq7EFU7k6G4/N99h6D1Y1FRWASCKeqLfuIiqRBv/fjMAwG/HGazOzFl2VZ1Tt/QISknU6L2IIU4UXILT7dheYHGeQ3fy+yk1WcARkO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089289; c=relaxed/simple;
	bh=3lJEiucPJ0U5M6VLeZLarNcfk2tPxDojdYxu7wYfCbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uEAxmNN1QfN3DzFMCazZDaZfjm78IbS7eLS1Yj732TmLA3XzSIR3RW4JLkd87eaJVbwWvorQCRB0eH/s2SmJIc8m2Ch1fcZHc+XcvP5FdwqpLG9V/ZR1B5VAoJqKRMygyj+NGFiIN62H7uh4mDm3/NI2Cl/9QZJfa8kU2X+ZWeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j1/JVvdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j1/JVvdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9572FC4CED1;
	Thu, 20 Feb 2025 22:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740089288;
	bh=3lJEiucPJ0U5M6VLeZLarNcfk2tPxDojdYxu7wYfCbM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j1/JVvdxxPnJxok9SV6Arj05GqLj+06+iw7UciSIOQMLwG/xKN3NOB+a2wL1pb6pQ
	 6mTqZ98RcryITYtAcPJXli043TjfwscYhIox6lvsJXmq3MPSFg62QKuMdu2ms77RuJ
	 Kf5akj9Bn7quorBz2L6cc03NoszNZ/2QePKG4zYs9G9sEou3H0Ic46xpFIiPMerV5k
	 1Niw75TyNZQEYu8yTFt7fyr9KfU85lD0FXWKoFnB09ZxvHIJ2wsbMgzf81fsv/uN2J
	 c6EVEvIz6I8IVLZWDS9uyya108OOyf1Nu3J7+9QVy6Qnuj7KGByjRtJw9cEOBEiEi9
	 hLANkPjam+Qnw==
Date: Thu, 20 Feb 2025 14:08:06 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Youling Tang <youling.tang@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	k2ci <kernel-bot@kylinos.cn>, Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] objtool: Add bch2_trans_unlocked_or_in_restart_error()
 to bcachefs noreturns
Message-ID: <20250220220806.cv6rnqefseckzlzm@jpoimboe>
References: <20250218064230.219997-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250218064230.219997-1-youling.tang@linux.dev>

On Tue, Feb 18, 2025 at 02:42:30PM +0800, Youling Tang wrote:
> From: Youling Tang <tangyouling@kylinos.cn>
> 
> Fix the following objtool warning during build time:
> fs/bcachefs/btree_cache.o: warning: objtool: btree_node_lock.constprop.0() falls through to next function bch2_recalc_btree_reserve()
> fs/bcachefs/btree_update.o: warning: objtool: bch2_trans_update_get_key_cache() falls through to next function need_whiteout_for_snapshot()
> 
> bch2_trans_unlocked_or_in_restart_error() is an Obviously Correct (tm)
> panic() wrapper, add it to the list of known noreturns.
> 
> Fixes: b318882022a8 ("bcachefs: bch2_trans_verify_not_unlocked_or_in_restart()")
> Reported-by: k2ci<kernel-bot@kylinos.cn>
> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>

Peter, can you take this one?

-- 
Josh
